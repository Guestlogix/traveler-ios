//
//  AggregatedPassesViewController.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-06-02.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

public protocol AggregatedPassesViewControllerDelegate: class {
    func aggregatedPasssesViewControllerDidChangePreferredContentSize(_ controller: AggregatedPassesViewController)
}

open class AggregatedPassesViewController: UITableViewController {
    var passes: [Pass]?

    weak var delegate: AggregatedPassesViewControllerDelegate?

    private var passQuantity = [Pass: Int]()
    private var aggregateInfo = [(name: String, quantity: Int, total: String?)]()

    override open func viewDidLoad() {
        super.viewDidLoad()

        passes?.forEach({ passQuantity[$0] = (passQuantity[$0] ?? 0) + 1 })

        for (pass, quantity) in passQuantity {
            let total = pass.price.valueInBaseCurrency * Double(quantity)
            aggregateInfo.append((pass.name, quantity, total.priceDescription()))
        }

        updatePreferredContentSize()
    }

    private func updatePreferredContentSize() {
        tableView.layoutIfNeeded()
        preferredContentSize = tableView.contentSize
        delegate?.aggregatedPasssesViewControllerDidChangePreferredContentSize(self)
    }

    // MARK: UITableViewDataSource

    override open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aggregateInfo.count
    }

    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "passCell", for: indexPath) as! PassCell
        let passInfo = aggregateInfo[indexPath.row]
        cell.passTypeLabel.text = "\(passInfo.name) x\(passInfo.quantity)"
        cell.priceLabel.text = passInfo.total
        return cell
    }
}
