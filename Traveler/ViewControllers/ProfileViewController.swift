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

// TODO: Remove TravelerRoute mock and profileData mock

struct ProfileData {
    var title: String
    var value: String
}

var profileData = [ProfileData(title: "Name", value: "John Doe"),
                   ProfileData(title: "Email", value: "johndoe@email.com"),
                   ProfileData(title: "Payment Info", value: "Visa ending in 8932"),
                    ProfileData(title: "Address", value: "123 Home Street"),
                    ProfileData(title: "Phone Number", value: "123-456-7890"),
                    ProfileData(title: "Language", value: "English")]

class ProfileViewController: UITableViewController {
    @IBOutlet weak var image: UIImageView!

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 1:
            return 2
        default:
            return profileData.count
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
        case (0, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCellIdentifier", for: indexPath) as! ProfileCell
            cell.titleLabel.text = profileData[indexPath.row].title
            cell.valueLabel.text = profileData[indexPath.row].value
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
