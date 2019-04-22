//
//  ProfileViewController.swift
//  Traveler
//
//  Created by Dorothy Fu on 2019-03-19.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit
import TravelerKitUI


class ProfileViewController: UITableViewController {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!

    var profile: Profile?

    override func viewDidLoad() {
        guard profile != nil && profile?.firstName != nil else {
            return
        }

        nameLabel.text = "\(profile?.firstName ?? "") \(profile?.lastName ?? "")"
    }

    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as SettingsViewController):
            vc.profile = profile
        default:
            Log("Unknown segue", data: nil, level: .warning)
            break
        }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default:
            Log("Invalid Section", data: section, level: .error)
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 60
        default:
            return 44
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row) {
        case (0, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCellIdentifier", for: indexPath) as! ProfileCell
            cell.titleLabel.text = "Email"
            cell.valueLabel.text = "\(profile?.email ?? "")"
            return cell
        case (1, 0):
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoButtonCellIdentifier", for: indexPath) as! InfoButtonCell
            cell.label.text = "Orders"
            return cell
        case (1, 1):
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoButtonCellIdentifier", for: indexPath) as! InfoButtonCell
            cell.label.text = "Settings"
            return cell
        default:
            fatalError("Invalid indexPath")
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch(indexPath.section, indexPath.row) {
        case (1, 1):
            self.performSegue(withIdentifier: "settingsSegue", sender: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}
