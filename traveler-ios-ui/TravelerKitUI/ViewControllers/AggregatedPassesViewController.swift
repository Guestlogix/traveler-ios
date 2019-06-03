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
    internal var passes:[Pass]?

    weak var delegate: AggregatedPassesViewControllerDelegate?

    private var passQuantity:[Pass:Int]?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let passes = passes else {
            Log("No passes", data: nil, level: .error)
            return
        }

        passQuantity = [Pass:Int]()

        _ = passes.compactMap({
            if let quantity = passQuantity?[$0] {
                passQuantity?[$0] = quantity + 1
            } else {
                passQuantity?[$0] = 1
            }
        })

        var size = CGSize(width: view.frame.width, height: 0)
        let count = passQuantity?.aggregatedPassInfo.count ?? 0

        for i in 0..<count {
            let indexPath = IndexPath(row: i, section: 0)
            let height = tableView(tableView, heightForRowAt: indexPath)
            size.height += height
        }

        preferredContentSize = size

        delegate?.aggregatedPasssesViewControllerDidChangePreferredContentSize(self)
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passQuantity?.aggregatedPassInfo.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "passCell", for: indexPath) as! PassCell
        let passInfo = passQuantity?.aggregatedPassInfo[indexPath.row]
        cell.passTypeLabel.text = "\(passInfo?.name ?? "") x\(passInfo?.quantity ?? 0)"
        cell.priceLabel.text = passInfo?.total
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
