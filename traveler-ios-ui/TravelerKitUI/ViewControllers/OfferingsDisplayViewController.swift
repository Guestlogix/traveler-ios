//
//  OfferingsDisplayViewController.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-11-28.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

public protocol OfferingsDisplayViewControllerDelegate: class {
    func offeringsDisplayViewControllerDidChangePreferredContentSize(_ controller: OfferingsDisplayViewController)
}

open class OfferingsDisplayViewController: UITableViewController {
    var offeringsGroup: [PartnerOfferingGroup]?
    weak var delegate: OfferingsDisplayViewControllerDelegate?

    private var isExpandedCellInGroup: [[Bool]]?

    let cellIdentifier = "optionCell"

    override open func viewDidLoad() {
        super.viewDidLoad()

        updatePreferredContentSize()

        // Initialize array of groups to keep track of expanded cells.
        isExpandedCellInGroup = offeringsGroup.map{$0.map { (group) -> [Bool] in
            return [Bool](repeating: false, count: group.offerings.count)
            }}
    }

    func updatePreferredContentSize() {
        tableView.layoutIfNeeded()
        preferredContentSize = tableView.contentSize
        delegate?.offeringsDisplayViewControllerDidChangePreferredContentSize(self)
    }

    // MARK: - Table view data source

    override open func numberOfSections(in tableView: UITableView) -> Int {
        return offeringsGroup?.count ?? 0
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return offeringsGroup?[section].offerings.count ?? 0
    }

    override open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return offeringsGroup?[section].title
    }

    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ExpandingCell

        cell.isExpanded = isExpandedCellInGroup?[indexPath.section][indexPath.row]
        cell.descriptionLabel.text = offeringsGroup?[indexPath.section].offerings[indexPath.row].attributedDescription?.string
        cell.titleLabel.text = offeringsGroup?[indexPath.section].offerings[indexPath.row].name
        cell.productImage?.image = nil

        if let imageURL = offeringsGroup?[indexPath.section].offerings[indexPath.row].iconURL {
            AssetManager.shared.loadImage(with: imageURL) { (image) in
                cell.productImage?.image = image
            }
        }

        return cell
    }

    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentState = isExpandedCellInGroup?[indexPath.section][indexPath.row] ?? true
        isExpandedCellInGroup?[indexPath.section][indexPath.row]  = !currentState

        tableView.reloadRows(at: [indexPath], with: .automatic)
        updatePreferredContentSize()
    }
}
