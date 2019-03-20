//
//  SettingsViewController.swift
//  Traveler
//
//  Created by Dorothy Fu on 2019-03-20.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit
import TravelerKitUI

class SettingsViewController: UITableViewController {
    let appVersion: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? ""

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 2
        case 1:
            return 2
        case 2:
            return 1
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoButtonCellIdentifier", for: indexPath) as! InfoButtonCell
            cell.label.text = "Legal Information"
            return cell
        case (0, 1):
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoButtonCellIdentifier", for: indexPath) as! InfoButtonCell
            cell.label.text = "Privacy Policy"
            return cell
        case (1, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCellIdentifier", for: indexPath) as! ButtonCell
            cell.button.setTitle("Delete Profile", for: .normal)
            return cell
        case (1, 1):
            let cell = tableView.dequeueReusableCell(withIdentifier: "buttonCellIdentifier", for: indexPath) as! ButtonCell
            cell.button.setTitle("Sign Out", for: .normal)
            return cell
        case (2, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "staticInfoCellIdentifier", for: indexPath) as! StaticInfoCell
            cell.label.text = "App Version: \(appVersion)"
            return cell
        default:
            fatalError("Invalid indexPath")
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
