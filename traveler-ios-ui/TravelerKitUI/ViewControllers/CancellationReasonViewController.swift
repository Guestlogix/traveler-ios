//
//  CancellationReasonViewController.swift
//  TravelerKitUI
//
//  Created by Ben Ruan on 2019-11-04.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

public protocol CancellationReasonViewControllerDelegate: class {
    func cancellationReasonViewController(_ controller: CancellationReasonViewController, didCancel order:Order)
    func cancellationReasonViewControllerDidExpire(_ controller: CancellationReasonViewController)
}

open class CancellationReasonViewController: UITableViewController {
    @IBOutlet weak var explanationInputTextField: UITextField!

    var quote: CancellationQuote?
    weak var delegate: CancellationReasonViewControllerDelegate?

    private var explanation: String?
    private var selectedReasonIndexPath: IndexPath?

    override public func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: UITableViewDataSource

    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quote!.cancellationReasons.count
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cancelReasonCell", for: indexPath) as! InfoCell
        cell.titleLabel.text = quote!.cancellationReasons[indexPath.row].description
        cell.accessoryType = indexPath == selectedReasonIndexPath ? .checkmark : .none

        return cell
    }

    // MARK: UITableViewDelegate

    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousIndexPath = selectedReasonIndexPath
        selectedReasonIndexPath = indexPath
        let selectedReason = quote!.cancellationReasons[indexPath.row]

        let required = selectedReason.explanationRequired ? "(Required)" : "(Optional)"
        explanationInputTextField.placeholder = "Please provide an explanation. \(required)"

        tableView.reloadRows(at: [previousIndexPath, selectedReasonIndexPath].compactMap({$0}), with: .automatic)
    }

    @IBAction func didConfirm(_ sender: Any) {
        guard let indexPath = selectedReasonIndexPath else {
            let alert = UIAlertController(title: "Please select a cancellation reason", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)

            return
        }

        let cancellationRequest = CancellationRequest(quote: quote!, reason: quote!.cancellationReasons[indexPath.row], explanation: explanation)

        let alert = UIAlertController(title: "Are you sure you want to cancel your order?", message: nil, preferredStyle: .alert)
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            ProgressHUD.show()
            Traveler.cancelOrder(cancellationRequest, delegate: self)
        }

        alert.addAction(noAction)
        alert.addAction(yesAction)

        present(alert, animated: true, completion: nil)
    }

    @IBAction func didClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func textFieldValueDidChange(_ textField: UITextField) {
        explanation = (textField.text?.isEmpty ?? true) ? nil : textField.text
    }
}

extension CancellationReasonViewController: CancellationDelegate {
    public func cancellationDidSucceed(order: Order) {
        ProgressHUD.hide()
        delegate?.cancellationReasonViewController(self, didCancel: order)
        NotificationCenter.default.post(name: .orderDidCancel, object: self, userInfo: [orderKey: order])
    }

    public func cancellationDidFailWith(_ error: Error) {
        ProgressHUD.hide()

        switch error {
        case CancellationError.expiredQuote:
            delegate?.cancellationReasonViewControllerDidExpire(self)
        default:
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
}
