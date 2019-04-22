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
import GoogleSignIn

class SettingsViewController: UITableViewController {
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var signOutButton: UIButton!

    var profile: Profile?

    let appVersion: String = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String ?? ""

    override func viewDidLoad() {
        super.viewDidLoad()

        appVersionLabel.text = "App Version: \(appVersion)"
    }

    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as MainViewController):
            vc.profile = nil
            vc.reloadAuthButton()
        default:
            Log("Unknown segue", data: nil, level: .warning)
            break
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (1, 0):
            showAlert(withTitle:"Are you sure you want to sign out of your profile?", withMessage: "Your order history will only be visible once you sign in.")
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension SettingsViewController {
    func showAlert(withTitle title: String, withMessage message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default, handler: { action in
            Guest.logOut()
            self.performSegue(withIdentifier: "exitSegue", sender: self)
        })
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: { action in })
        alert.addAction(ok)
        alert.addAction(cancel)
        DispatchQueue.main.async(execute: {
            self.present(alert, animated: true)
        })
    }
}
