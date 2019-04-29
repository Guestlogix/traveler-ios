//
//  OrdersViewController.swift
//  Traveler
//
//  Created by Dorothy Fu on 2019-04-23.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit
import TravelerKitUI

class OrdersViewController: UITableViewController {
    var profile: Profile?
    var orders: [Order]?

    override func numberOfSections(in tableView: UITableView) -> Int {
        if orders == nil && orders?.isEmpty ?? true {
            self.tableView.setEmptyMessage()
            return 0
        } else {
            return 1
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard orders != nil && orders?.count != 0 else {
            return 1
        }

        return orders!.count
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 176
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if orders?.isEmpty ?? true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cardCellIdentifier", for: indexPath) as! CardCell
            cell.orderNumberLabel.text = "Don't display anything"
            return cell
        } else {
            let order = orders?[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "cardCellIdentifier", for: indexPath) as! CardCell
            cell.orderNumberLabel.text = "Order Number"
            cell.dateLabel.text = DateFormatter.longFormatter.string(from: order!.createdDate)
            cell.titleLabel.text = "Product Name"
            return cell
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UITableView {
    func setEmptyMessage() {
        let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        messageLabel.text = "No orders available. Go buy something :)"
        messageLabel.textColor = .black
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center;
        messageLabel.sizeToFit()

        self.backgroundView = messageLabel;
        self.separatorStyle = .none;
    }
}
