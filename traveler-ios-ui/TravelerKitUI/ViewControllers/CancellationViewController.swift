//
//  CancelOrderViewController.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-06-04.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

protocol CancellationViewControllerDelegate: class {
    func cancellationViewController(_ controller: CancellationViewController, didCancel order:Order)
    func cancellationViewControllerDidExpire(_ controller: CancellationViewController)
}

class CancellationViewController: UITableViewController {
    @IBOutlet weak var explanationInputTextField: UITextField!

    var quote: CancellationQuote?
    weak var delegate: CancellationViewControllerDelegate?

    private var selectedReason: CancellationReason?
    private var explanation: String?
    private var selectedReasonIndexPath: IndexPath?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return (quote?.products.count ?? 0) + 1
        } else {
            return (quote?.cancellationReasons.count ?? 0)
        }
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 1 {
            return "Please select a reason for cancellation"
        } else {
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 0 {
            return " "
        } else {
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row == (quote?.products.count ?? 0)) {
        case (0, true):
            let cell = tableView.dequeueReusableCell(withIdentifier: "totalRefundCell", for: indexPath) as! InfoCell
            cell.secondValueLabel?.text = quote?.totalRefund.localizedDescriptionInBaseCurrency

            return cell
        case (0, false):
            let cell = tableView.dequeueReusableCell(withIdentifier: "productCancelCell", for: indexPath) as! InfoCell

            cell.titleLabel.text = quote?.products[indexPath.row].title
            let percentageFee = quote!.percentageFee(product: quote!.products[indexPath.row])
            cell.valueLabel.text = "Cancellation Fee \(percentageFee)%"
            cell.secondValueLabel?.text = quote?.products[indexPath.row].cancellationCharge.localizedDescriptionInBaseCurrency

            return cell
        case (_, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: "cancelReasonCell", for: indexPath) as! InfoCell
            cell.titleLabel.text = quote?.cancellationReasons[indexPath.row].value
            cell.accessoryType = indexPath == selectedReasonIndexPath ? .checkmark : .none

            return cell
        }
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousIndexPath = selectedReasonIndexPath
        selectedReasonIndexPath = indexPath
        selectedReason = quote?.cancellationReasons[indexPath.row]

        let required = (selectedReason?.explanationRequired ?? false) ? "(Required)" : "(Optional)"
        explanationInputTextField.placeholder = "Please provide an explanation. \(required)"

        tableView.reloadRows(at: [previousIndexPath, selectedReasonIndexPath].compactMap({$0}), with: .automatic)
    }

    @IBAction func didConfirm(_ sender: Any) {
        guard let quote = quote else {
            Log("Cancellation quote not found.", data: nil, level: .error)
            return
        }

        guard let reason = selectedReason else {
            let alert = UIAlertController(title: "Please select a cancellation reason", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)

            return
        }

        let cancellationRequest = CancellationRequest(quote: quote, reason: reason, explanation: explanation)

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

extension CancellationViewController: CancellationDelegate {
    func cancellationDidSucceed(order: Order) {
        ProgressHUD.hide()
        delegate?.cancellationViewController(self, didCancel: order)
        NotificationCenter.default.post(name: .orderDidCancel, object: self, userInfo: [orderKey: order])
    }

    func cancellationDidFailWith(_ error: Error) {
        ProgressHUD.hide()

        switch error {
        case CancellationError.expiredQuote:
            delegate?.cancellationViewControllerDidExpire(self)
        default:
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
}

extension CancellationQuote {
    func percentageFee(product: ProductCancellationQuote) -> Double {
        return (product.cancellationCharge.valueInBaseCurrency / (product.totalRefund.valueInBaseCurrency + product.cancellationCharge.valueInBaseCurrency)) * 100
    }
}
