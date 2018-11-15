//
//  InfoViewController.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-11-08.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

protocol AttributesViewControllerDelegate: class {
    func attributesViewControllerDidChangePreferredContentSize(_ controller: AttributesViewController)
}

let attributeCellIdentifier = "attributeCellIdentifier"

class AttributesViewController: UITableViewController {
    var attributes: [Attribute]?
    weak var delegate: AttributesViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        var size = CGSize(width: view.frame.width, height: 0)
        let count = attributes?.count ?? 0

        for i in 0..<count {
            let indexPath = IndexPath(row: i, section: 0)
            let height = tableView(tableView, heightForRowAt: indexPath)
            size.height += height
        }

        preferredContentSize = size

        delegate?.attributesViewControllerDidChangePreferredContentSize(self)
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributes?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: attributeCellIdentifier, for: indexPath) as! InfoCell
        var attribute = attributes![indexPath.row]
        cell.titleLabel.text = attribute.label
        let value = attribute.attributedValue
        value?.setFontFace(font: UIFont.systemFont(ofSize: 15), color: UIColor.darkGray)
        cell.valueLabel.attributedText = value
        return cell
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let attribute = attributes![indexPath.row]
        let boundingSize = CGSize(width: tableView.bounds.width - 32, height: 0)

        return InfoCell.boundingSize(title: attribute.label,
                                     value: attribute.value,
                                     with: boundingSize).height + 2
    }
}
