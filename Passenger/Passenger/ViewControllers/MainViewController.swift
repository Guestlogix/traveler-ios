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
    @IBOutlet weak var tableView: UITableView!

    private var flights = [Flight]()

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
        self.flights.append(contentsOf: flights)
        self.tableView.reloadData()
        controller.dismiss(animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return flights.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: flightCellIdentifier, for: indexPath)
        let flight = flights[indexPath.row]
        cell.textLabel?.text = "\(flight.departureAirport.code.uppercased()) ✈ \(flight.arrivalAirport.code.uppercased())"
        return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Remove") { (action, indexPath) in
            self.flights.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }

        return [deleteAction]
    }
}
