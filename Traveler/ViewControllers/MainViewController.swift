//
//  MainViewController.swift
//  Traveler
//
//  Created by Ata Namvari on 2018-10-17.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import UIKit
import TravelerKit
import TravelerKitUI

protocol MainViewControllerDelegate: class {
    func mainViewControllerDidSignIn(_ controller: MainViewController)
    func mainViewControllerDidSignOut(_ controller: MainViewController)
}

let flightCellHeight: CGFloat = 44

class MainViewController: UIViewController {
    // TODO: Random test. Should pick up this TODO
    // TODO : Another test
    @IBOutlet weak var authButton: UIBarButtonItem!
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var containerView: UIView!

    var profile: Profile?
    weak var delegate: MainViewControllerDelegate?

    private var flights = [Flight]()
    private var selectedFlight: Flight?

    override func viewDidLoad() {
        super.viewDidLoad()

        reloadAuthButton()

        NotificationCenter.default.addObserver(self, selector: #selector(filterStaleFlights), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(signInStatusDidChange(_:)), name: .signInStatusDidChange, object: nil)

        performSegue(withIdentifier: "catalogSegue", sender: nil)
    }

    @objc func filterStaleFlights() {
        let filteredFlights = flights.filter {
            $0.departureDate > Date()
        }

        guard flights.count > filteredFlights.count else {
            return
        }

        flights = filteredFlights
        self.updateTableViewHeight()
        self.performSegue(withIdentifier: "catalogSegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue, segue.destination) {
        case (_, let detailsNavVC as UINavigationController) where segue.identifier == "flightDetailsSegue":
            let flightDetailsVC = detailsNavVC.topViewController as? FlightDetailsViewController
            flightDetailsVC?.flight = selectedFlight
        case (_, let navVC as UINavigationController) where segue.identifier == "addFlightSegue":
            let lookupVC = navVC.topViewController as? FlightLookupViewController
            lookupVC?.delegate = self
        case (_, let navVC as UINavigationController) where segue.identifier == "profileSegue":
            let profileVC = navVC.topViewController as? ProfileViewController
            profileVC?.delegate = self
            profileVC?.profile = profile
            profileVC?.flights = flights
        case (let segue as ContainerEmbedSegue, let catalogVC as PassengerCatalogViewController):
            segue.containerView = containerView
            catalogVC.query = CatalogQuery(flights: flights)
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    @objc func signInStatusDidChange(_ note: Notification) {
        self.profile = note.userInfo?[profileKey] as? Profile
        reloadAuthButton()
    }

    func reloadAuthButton() {
        authButton.title = profile == nil ? "Sign In" : "Profile"
    }

    // MARK: Actions

    @IBAction private func unwindToMainViewController(_ segue: UIStoryboardSegue) {}

    @IBAction func didPressAuthButton(_ sender: Any) {
        if profile == nil {
            delegate?.mainViewControllerDidSignIn(self)
        } else {
            performSegue(withIdentifier: "profileSegue", sender: nil)
        }
    }
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
    
    func flightLookUpViewController(_ controller: FlightLookupViewController, canAdd flights: Flight) -> Bool {
        return !self.flights.contains(where: {$0 == flights})
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
        selectedFlight = flights[indexPath.row]
        self.performSegue(withIdentifier: "flightDetailsSegue", sender: nil)
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

extension MainViewController: ProfileViewControllerDelegate {
    func profileViewControllerDidLogOut(_ controller: ProfileViewController) {
        delegate?.mainViewControllerDidSignOut(self)

        controller.dismiss(animated: true)
    }
}
