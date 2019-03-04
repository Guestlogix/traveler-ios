//
//  MainViewController.swift
//  Passenger
//
//  Created by Ata Namvari on 2018-10-17.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import UIKit
import TravelerKit
import TravelerKitUI

let flightCellHeight: CGFloat = 44

class MainViewController: UIViewController {
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!

    private var flights = [Flight]()

    override func viewDidLoad() {
        super.viewDidLoad()

        performSegue(withIdentifier: "catalogSegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue, segue.destination) {
        case (_, let navVC as UINavigationController) where segue.identifier == "addFlightSegue":
            let lookupVC = navVC.topViewController as? FlightLookupViewController
            lookupVC?.delegate = self
        case (let segue as ContainerEmbedSegue, let catalogVC as PassengerCatalogViewController):
            segue.containerView = containerView
            catalogVC.query = CatalogQuery(flights: flights)
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
        self.updateTableViewHeight()
        self.performSegue(withIdentifier: "catalogSegue", sender: nil)
        controller.dismiss(animated: true)
    }

    func updateTableViewHeight() {
        self.tableViewHeightConstraint.constant = CGFloat(flights.count) * flightCellHeight
    }
    
    func flightLookUpViewController(_ controller: FlightLookupViewController, canAdd flights: [Flight]) -> Bool {
        return !self.flights.contains(where: {$0 == flights[0]})
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
            self.updateTableViewHeight()
            self.performSegue(withIdentifier: "catalogSegue", sender: nil)
        }

        return [deleteAction]
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return flightCellHeight
    }
}
