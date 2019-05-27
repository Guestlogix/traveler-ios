//
//  OrderDetailViewController.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-05-23.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

let orderDetailCellIdentifier = "orderDetailCellIdentifier"
let productCellIdentifier = "productCellIdentifier"
let billingCellIdentifier = "billingCellIdentifier"
let cancelOrderCellIdentifier = "cancelOrderCellIdentifier"

class OrderDetailViewController: UITableViewController {
    public var order: Order?

    private var numberOfRows = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        numberOfRows = (order?.products.count ?? 0) + 3
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return numberOfRows
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {

            let cell = tableView.dequeueReusableCell(withIdentifier: orderDetailCellIdentifier, for: indexPath) as! OrderDetailCell
            cell.orderNumberLabel.text = order?.referenceNumber ?? "Order number"
            cell.dateLabel.text = DateFormatter.dateOnlyFormatter.string(from: order!.createdDate)
            cell.priceLabel.text = order?.total.localizedDescription
            return cell

        } else if indexPath.row > 0 && indexPath.row <= order!.products.count{

            let cell = tableView.dequeueReusableCell(withIdentifier: productCellIdentifier, for: indexPath) as! ProductCell
            let product = order?.products[indexPath.row - 1] as! BookableProduct
            cell.productNameLabel.text = product.title
            cell.dateLabel.text = DateFormatter.dateOnlyFormatter.string(from: product.eventDate)
            cell.priceLabel.text = product.price.localizedDescription
            return cell

        } else if indexPath.row == numberOfRows - 2 {

            let cell = tableView.dequeueReusableCell(withIdentifier: billingCellIdentifier, for: indexPath) as! BillingCell
            cell.delegate = self
            cell.creditCardLabel.text = "Ending in: \(order?.last4Digits ?? "")"
            return cell

        } else {

            let cell = tableView.dequeueReusableCell(withIdentifier: cancelOrderCellIdentifier, for: indexPath) as! CancelCell
            cell.delegate = self
            return cell

        }
    }

    //MARK: - Table View Delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension OrderDetailViewController: CancelCellDelegate {

    func cancelButtonTapped(_ cell: CancelCell) {

    }

}

extension OrderDetailViewController: BillingCellDelegate {

    func emailButtonTapped(_ cell: BillingCell) {

    }
}


