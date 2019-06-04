//
//  CancelOrderViewController.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-06-04.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

class CancelOrderViewController: UITableViewController {
    @IBOutlet weak var totalRefundLabel: UILabel!

    internal var quote: CancellationQuote?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let quote = quote else {
            Log ("No quote", data: nil, level: .error)
            return
        }

        totalRefundLabel.text = quote.totalRefund.localizedDescription
    }

    @IBAction func didConfirm(_ sender: Any) {
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
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
}

extension CancelOrderViewController: ProductCancelCellDelegate {
    func productCancelDidPressButton(_ cell: ProductCancelCell) {
    }
}
