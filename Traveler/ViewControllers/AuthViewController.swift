//
//  AuthViewController.swift
//  Traveler
//
//  Created by Ata Namvari on 2019-03-28.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit
import GoogleSignIn

class AuthViewController: UIViewController {
    private var profile: Profile?

    override func viewDidLoad() {
        super.viewDidLoad()

        profile = UserDefaults.standard.object(forKey: profileKey) as? Profile

        Traveler.identify(profile?.travelerId, attributes: [:])

        GIDSignIn.sharedInstance()?.delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self

        performSegue(withIdentifier: "mainSegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let navVC as UINavigationController):
            let vc = navVC.topViewController as? MainViewController
            vc?.delegate = self
            vc?.profile = profile
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    private func presentError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: "There was an error signing in. \(error.localizedDescription)", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)

        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }
}

extension AuthViewController: MainViewControllerDelegate {
    func mainViewControllerDidSignIn(_ controller: MainViewController) {
        GIDSignIn.sharedInstance()?.signIn()
    }
}

extension AuthViewController: GIDSignInUIDelegate {
    func sign(inWillDispatch signIn: GIDSignIn!, error: Error!) {
        guard let error = error else {
            return
        }

        presentError(error)
    }
}

extension AuthViewController: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        guard error == nil else {
            presentError(error)
            return
        }

        Guest.fetchProfile(user) { [weak self] (profile, error) in
            guard let profile = profile else {
                self?.presentError(error!)
                return
            }

            Traveler.identify(profile.travelerId, attributes: [:])

            NotificationCenter.default.post(name: .didSignIn, object: nil, userInfo: [profileKey: profile])
        }
    }
}
