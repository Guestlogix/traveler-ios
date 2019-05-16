//
//  DummyTableViewController.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-05-10.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit

let dummyCellIdentifier = "dummyCellIdentifier"

class DummyTableViewController: UITableViewController {
    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(tableView.bounds.height / tableView.rowHeight)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: dummyCellIdentifier, for: indexPath)
        return cell
    }
}
