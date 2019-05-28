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
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderPriceLabel: UILabel!
    @IBOutlet weak var creditCardLabel: UILabel!

    public var order: Order?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        orderNumberLabel.text = order?.referenceNumber ?? "Order number"
        orderDateLabel.text = DateFormatter.dateOnlyFormatter.string(from: order!.createdDate)
        orderPriceLabel.text = order?.total.localizedDescription
        creditCardLabel.text = "Visa ending in: \(order?.last4Digits ?? "")"
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order?.products.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = order?.products[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: productCellIdentifier, for: indexPath) as! ProductCell
        cell.productNameLabel.text = product?.title
        if let bookableProduct = product as? BookableProduct {
            cell.dateLabel.text = DateFormatter.dateOnlyFormatter.string(from: bookableProduct.eventDate)
            cell.priceLabel.text = bookableProduct.price.localizedDescription
        }
        return cell
    }

    @IBAction func didCancelOrder(_ sender: Any) {
        
    }

    @IBAction func didRequestTickets(_ sender: Any) {

    }
}