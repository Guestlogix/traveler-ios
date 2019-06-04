//
//  CancelOrderViewController.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-06-04.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

protocol CancelOrderViewControllerDelegate {
    func orderCancelSucceed(with order:Order)
}

class CancelOrderViewController: UITableViewController {
    @IBOutlet weak var totalRefundLabel: UILabel!

    internal var quote: CancellationQuote?
    internal var delegate:CancelOrderViewControllerDelegate?

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

        cell.delegate = self
        cell.productNameLabel.text = quote?.products[indexPath.row].title
        let percentageFee = (quote?.cancellationCharge.value ?? 0.0/quote!.products[indexPath.row].totalRefund.value ) * 100.0
        cell.cancellationFeeLabel.text = "Cancellation Fee \(percentageFee)%"
        cell.refundLabel.text = quote?.products[indexPath.row].totalRefund.localizedDescription

        return cell
    }

    @IBAction func didConfirm(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure you want to cancel your order?", message: nil, preferredStyle: .alert)
        let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
            ProgressHUD.show()
            Traveler.cancelOrder(quote: self.quote!, delegate: self)
        }

        alert.addAction(noAction)
        alert.addAction(yesAction)

        present(alert, animated: true, completion: nil)
    }

    @IBAction func didClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension CancelOrderViewController: CancellationDelegate{
    
    func cancellationDidSucceed(_ order: Order) {
        ProgressHUD.hide()
        delegate?.orderCancelSucceed(with: order)
        dismiss(animated: true, completion: nil)
    }

    func cancellationDidFailWith(_ error: Error) {
        ProgressHUD.hide()
        var message = ""

        switch error {
        case CancellationError.expiredQuote:
            message = "Your quote has expired please try again"
        default:
            message = "There was a problem cancelling your order"
        }

        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

extension CancelOrderViewController: ProductCancelCellDelegate {
    func productCancelDidPressButton(_ cell: ProductCancelCell) {
    }
}
