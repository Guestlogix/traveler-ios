//
//  InfoViewController.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-08.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit
import TravelerKit

public protocol AttributesViewControllerDelegate: class {
    func attributesViewControllerDidChangePreferredContentSize(_ controller: AttributesViewController)
}

let attributeCellIdentifier = "attributeCellIdentifier"

open class AttributesViewController: UITableViewController {

    var attributes: [Attribute]?
    weak var delegate: AttributesViewControllerDelegate?

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.layoutIfNeeded()
        preferredContentSize = tableView.contentSize

        delegate?.attributesViewControllerDidChangePreferredContentSize(self)
    }

    // MARK: UITableViewDataSource

    override open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributes?.count ?? 0
    }

    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: attributeCellIdentifier, for: indexPath) as! InfoCell
        let attribute = attributes![indexPath.row]
        cell.titleLabel.text = attribute.label
        let value = attribute.attributedValue
        value?.setFontFace(font: UIFont.systemFont(ofSize: 15), color: UIColor.darkGray)
        cell.valueLabel.attributedText = value
        return cell
    }

    // MARK: UITableViewDelegate

    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let attribute = attributes![indexPath.row]
        let boundingSize = CGSize(width: tableView.bounds.width - 32, height: 0)

        return InfoCell.boundingSize(title: attribute.label,
                                     value: attribute.value,
                                     with: boundingSize).height + 2
    }
}
