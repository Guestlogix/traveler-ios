//
//  ProfileViewController.swift
//  Traveler
//
//  Created by Ata Namvari on 2019-05-06.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKitUI
import TravelerKit

protocol ProfileViewControllerDelegate: class {
    func profileViewControllerDidLogOut(_ controller: ProfileViewController)
}

class ProfileViewController: UITableViewController {
    @IBOutlet weak var emailLabel: UILabel!

    var profile: Profile?
    weak var delegate: ProfileViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        emailLabel.text = profile?.email
        navigationItem.title = profile?.firstName
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let orderVC as OrdersViewController):
            orderVC.query = OrderQuery(offset: 0, limit: 10, from: nil, to: Date())
        case (_, let vc as SettingsViewController):
            vc.delegate = self
        case ("exitSegue"?, _):
            break
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }
}

extension ProfileViewController: SettingsViewControllerDelegate {
    func settingsViewControllerDidLogOut(_ controller: SettingsViewController) {
        delegate?.profileViewControllerDidLogOut(self)
    }
}
