//
//  AggregatedPassesViewController.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-06-02.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

protocol AggregatedPassesViewControllerDelegate: class {
    func aggregatedPasssesViewControllerDidChangePreferredContentSize(_ controller: AggregatedPassesViewController)
}

class AggregatedPassesViewController: UITableViewController {
    var passes:[Pass]?

    weak var delegate: AggregatedPassesViewControllerDelegate?

    private var passQuantity = [Pass:Int]()

    override func viewDidLoad() {
        super.viewDidLoad()

        _ = passes?.compactMap({ passQuantity[$0] = (passQuantity[$0] ?? 0) + 1 })

        updatePreferredContentSize()
    }

    private func updatePreferredContentSize() {
        tableView.layoutIfNeeded()
        preferredContentSize = tableView.contentSize
        delegate?.aggregatedPasssesViewControllerDidChangePreferredContentSize(self)
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passQuantity.aggregatedPassInfo.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "passCell", for: indexPath) as! PassCell
        let passInfo = passQuantity.aggregatedPassInfo[indexPath.row]
        cell.passTypeLabel.text = "\(passInfo.name) x\(passInfo.quantity)"
        cell.priceLabel.text = passInfo.total
        return cell
    }
}

extension Dictionary where Key == Pass, Value == Int {
    var aggregatedPassInfo: [(name: String, quantity: Int, total: String?)] {
        var aggregateInfo = [(name: String, quantity: Int, total: String?)]()
        for (pass, quantity) in self {
            let total = pass.price.value * Double(quantity)
            aggregateInfo.append((pass.name, quantity, total.priceDescription()))
        }
        return aggregateInfo
    }
}
