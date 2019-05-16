//
//  SettingsViewController.swift
//  Traveler
//
//  Created by Ata Namvari on 2019-05-15.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: class {
    func settingsViewControllerDidLogOut(_ controller: SettingsViewController)
}

class SettingsViewController: UITableViewController {
    weak var delegate: SettingsViewControllerDelegate?

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        guard let identifier = tableView.cellForRow(at: indexPath)?.reuseIdentifier else {
            return
        }

        switch identifier {
        case "logOutCellIdentifier":
            let alert = UIAlertController(title: "Are you sure you want to log out?", message: nil, preferredStyle: .alert)
            let noAction = UIAlertAction(title: "No", style: .cancel, handler: nil)
            let yesAction = UIAlertAction(title: "Yes", style: .default) { _ in
                self.delegate?.settingsViewControllerDidLogOut(self)
            }

            alert.addAction(noAction)
            alert.addAction(yesAction)

            present(alert, animated: true)
        default:
            break
        }
    }
}
