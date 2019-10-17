//
//  DummyTableViewController.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-05-10.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit

let dummyCellIdentifier = "dummyCellIdentifier"

open class DummyTableViewController: UITableViewController {
    // MARK: UITableViewDataSource

    override public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(tableView.bounds.height / tableView.rowHeight)
    }

    override public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: dummyCellIdentifier, for: indexPath)
        cell.contentView.subviews.forEach({ $0.startShimmering() })
        return cell
    }
}
