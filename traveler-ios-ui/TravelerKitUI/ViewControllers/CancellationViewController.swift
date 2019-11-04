//
//  CancelOrderViewController.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-06-04.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

public protocol CancellationViewControllerDelegate: class {
    func cancellationViewController(_ controller: CancellationViewController, didCancel order:Order)
    func cancellationViewControllerDidExpire(_ controller: CancellationViewController)
}

open class CancellationViewController: UITableViewController {
    @IBOutlet weak var totalRefundLabel: UILabel!

    var quote: CancellationQuote?
    weak var delegate: CancellationViewControllerDelegate?

    override public func viewDidLoad() {
        super.viewDidLoad()

        totalRefundLabel.text = quote?.totalRefund.localizedDescriptionInBaseCurrency
    }

    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let vc as CancellationReasonViewController:
            vc.delegate = self
            vc.quote = quote
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    // MARK: UITableViewDataSource

    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quote?.products.count ?? 0
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "productCancelCell", for: indexPath) as! InfoCell

        cell.titleLabel.text = quote?.products[indexPath.row].title
        let percentageFee = quote!.percentageFee(product: quote!.products[indexPath.row])
        cell.valueLabel.text = "Cancellation Fee \(percentageFee)%"
        cell.secondValueLabel?.text = quote?.products[indexPath.row].cancellationCharge.localizedDescriptionInBaseCurrency

        return cell
    }

    @IBAction func didConfirm(_ sender: Any) {
        guard let _ = quote else {
            Log("No cancellation quote", data: nil, level: .error)
            return
        }

        performSegue(withIdentifier: "cancellationReasonSegue", sender: nil)
    }

    @IBAction func didClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension CancellationViewController: CancellationReasonViewControllerDelegate {
    public func cancellationReasonViewController(_ controller: CancellationReasonViewController, didCancel order: Order) {
        delegate?.cancellationViewController(self, didCancel: order)
    }

    public func cancellationReasonViewControllerDidExpire(_ controller: CancellationReasonViewController) {
        delegate?.cancellationViewControllerDidExpire(self)
    }
}

extension CancellationQuote {
    func percentageFee(product: ProductCancellationQuote) -> Double {
        return (product.cancellationCharge.valueInBaseCurrency / (product.totalRefund.valueInBaseCurrency + product.cancellationCharge.valueInBaseCurrency)) * 100
    }
}
