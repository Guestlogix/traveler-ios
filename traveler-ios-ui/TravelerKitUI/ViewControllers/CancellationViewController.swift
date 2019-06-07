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
    func cancellationViewController(_ controller: CancellationViewController, cancelationDidFail error: Error)
}

class CancellationViewController: UITableViewController {
    @IBOutlet weak var totalRefundLabel: UILabel!

    var quote: CancellationQuote?
    weak var delegate:CancellationViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let quote = quote else {
            Log ("No quote", data: nil, level: .error)
            return
        }

        totalRefundLabel.text = quote.totalRefund.localizedDescription
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quote?.products.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCancelCell", for: indexPath) as! ProductCancelCell

        cell.productNameLabel.text = quote?.products[indexPath.row].title
        let percentageFee = (quote?.cancellationCharge.value ?? 0.0/quote!.products[indexPath.row].totalRefund.value ) * 100.0
        cell.cancellationFeeLabel.text = "Cancellation Fee \(percentageFee)%"
        cell.refundLabel.text = quote?.products[indexPath.row].totalRefund.localizedDescription

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
    }

    func cancellationDidFailWith(_ error: Error) {
        ProgressHUD.hide()
        delegate?.cancellationViewController(self, cancelationDidFail: error)
    }
}
