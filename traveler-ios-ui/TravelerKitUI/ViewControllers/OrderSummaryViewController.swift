//
//  OrderSummaryViewController.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-02-01.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import UIKit
import TravelerKit

/// This view controller will potentially have embedded view controllers inside to support different type of orders

let orderItemCellIdentifier = "orderItemCellIdentifier"
let infoCellIdentifier = "infoCellIdentifier"
let headerViewIdentifier = "headerViewIdentifier"

class OrderSummaryViewController: UITableViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!

    var order: Order?
    var payment: Payment?

    override func viewDidLoad() {
        super.viewDidLoad()

        let bundle = Bundle(for: HeaderView.self)
        tableView.register(UINib(nibName: "HeaderView", bundle: bundle), forHeaderFooterViewReuseIdentifier: headerViewIdentifier)

        // TODO: This VC should account for multiple products as an Order can have multiple Products

        titleLabel.text = order?.products.first?.title
        dateLabel.text = order.flatMap { DateFormatter.dayNameMonthDayYear.string(from: $0.createdDate) }
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return (order?.products.first as? BookableProduct)?.passes.count ?? 0
        case 1:
            return payment?.attributes.count ?? 0
        default:
            fatalError("Invalid section")
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, let row):
            let cell = tableView.dequeueReusableCell(withIdentifier: orderItemCellIdentifier, for: indexPath) as! OrderItemViewCell
            let pass = (order!.products.first as? BookableProduct)?.passes[row]
            cell.titleLabel.text = pass?.name
            cell.subTitleLabel.text = pass?.description
            cell.priceLabel.text = pass?.price.localizedDescription
            return cell
        case (1, let row):
            let cell = tableView.dequeueReusableCell(withIdentifier: infoCellIdentifier, for: indexPath) as! InfoCell
            let attribute = payment!.attributes[row]
            cell.titleLabel.text = attribute.label
            cell.valueLabel.text = attribute.value
            return cell
        default:
            fatalError("Invalid IndexPath")
        }
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 1:
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerViewIdentifier) as! HeaderView
            headerView.titleLabel.text = "Billing Information"
            return headerView
        default:
            return nil
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 1:
            return 44
        default:
            return 0
        }
    }
}
