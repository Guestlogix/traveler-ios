//
//  MainViewController.swift
//  Passenger
//
//  Created by Ata Namvari on 2018-10-17.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import UIKit
import PassengerKit

class MainViewController: UIViewController {

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case ("addFlightSegue"?, let navVC as UINavigationController):
            let lookupVC = navVC.topViewController as? FlightLookupViewController
            lookupVC?.delegate = self
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    // MARK: Actions

    @IBAction private func unwindToMainViewController(_ segue: UIStoryboardSegue) {}
}

extension MainViewController: FlightLookupViewControllerDelegate {
    func flightLookupViewController(_ controller: FlightLookupViewController, didAdd flights: [Flight]) {
        // TODO: Add flights somewhere
        controller.dismiss(animated: true)
    }
}
