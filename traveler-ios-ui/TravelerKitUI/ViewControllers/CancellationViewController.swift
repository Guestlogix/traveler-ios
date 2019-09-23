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
    @IBOutlet weak var totalRefundLabel: UILabel!

    var quote: CancellationQuote?
    weak var delegate: CancellationViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        totalRefundLabel.text = quote?.totalRefund.localizedDescriptionInBaseCurrency
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quote?.products.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCancelCell", for: indexPath) as! InfoCell

        cell.titleLabel.text = quote?.products[indexPath.row].title
        let percentageFee = quote!.percentageFee(product: quote!.products[indexPath.row])
        cell.valueLabel.text = "Cancellation Fee \(percentageFee)%"
        cell.secondValueLabel?.text = quote?.products[indexPath.row].cancellationCharge.localizedDescriptionInBaseCurrency

        return cell
    }

    @IBAction func didConfirm(_ sender: Any) {
        if let quote = quote {
            let alert = UIAlertController(title: "Are you sure you want to cancel your order?", message: nil, preferredStyle: .alert)
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                ProgressHUD.show()
                Traveler.cancelOrder(quote: quote, delegate: self)
            }

            alert.addAction(noAction)
            alert.addAction(yesAction)

            present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func didClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
