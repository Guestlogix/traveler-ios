//
//  OptionsDisplayViewController.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-11-28.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

public protocol OptionsDisplayViewControllerDelegate: class {
    func optionsDisplayViewControllerDidChangePreferredContentSize(_ controller: OptionsDisplayViewController)
}

open class OptionsDisplayViewController: UITableViewController {

    var optionsGroup: [PartnerOfferingGroup]?
    weak var delegate: OptionsDisplayViewControllerDelegate?

    private var expandedGroup: [[Bool]]?
    override open func viewDidLoad() {
        super.viewDidLoad()

        updatePreferredContentSize()

        // Initialize array of groups to keep track of expanded cells.
        expandedGroup = optionsGroup.map{$0.map { (group) -> [Bool] in
            return [Bool](repeating: false, count: group.offerings.count)
            }}
    }

    func updatePreferredContentSize() {
        tableView.layoutIfNeeded()
        preferredContentSize = tableView.contentSize
        delegate?.optionsDisplayViewControllerDidChangePreferredContentSize(self)
    }

    // MARK: - Table view data source

    override open func numberOfSections(in tableView: UITableView) -> Int {
        return optionsGroup?.count ?? 0
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsGroup?[section].offerings.count ?? 0
    }

    override open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return optionsGroup?[section].title ?? ""
    }

    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "optionCell", for: indexPath) as! ExpandingCell

        cell.isExpanded = expandedGroup?[indexPath.section][indexPath.row]
        cell.descriptionLabel.text = optionsGroup?[indexPath.section].offerings[indexPath.row].attributedDescription?.string
        cell.titleLabel.text = optionsGroup?[indexPath.section].offerings[indexPath.row].name
        cell.productImage?.image = nil

        if let imageURL = optionsGroup?[indexPath.section].offerings[indexPath.row].iconURL {
            AssetManager.shared.loadImage(with: imageURL) { (image) in
                cell.productImage?.image = image
            }
        }

        return cell
    }

    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currentState = expandedGroup?[indexPath.section][indexPath.row] ?? true
        expandedGroup?[indexPath.section][indexPath.row]  = !currentState

        tableView.reloadRows(at: [indexPath], with: .automatic)
        updatePreferredContentSize()
    }
}
