//
//  FlightSearchResultViewController.swift
//  Passenger
//
//  Created by Ata Namvari on 2018-10-17.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import UIKit
import PassengerKit

protocol FlightSearchResultViewControllerDelegate: class {
    func flightSearchResultViewController(_ controller: FlightSearchResultViewController, didSelect flight: Flight)
}

let flightCellIdentifier = "flightCellIdentifier"

class FlightSearchResultViewController: UITableViewController {
    weak var delegate: FlightSearchResultViewControllerDelegate?
    var flights: [Flight]?

    override func numberOfSections(in tableView: UITableView) -> Int {
        return flights?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: flightCellIdentifier, for: indexPath) as! FlightCell
        let flight = flights![indexPath.section]

        cell.departureCityLabel.text = flight.departureAirport.city
        cell.departureIATALabel.text = flight.departureAirport.code
        cell.departureTimeLabel.text = DateFormatter.timeFormatter.string(from: flight.departureDate)
        cell.arrivalCityLabel.text = flight.arrivalAirport.city
        cell.arrivalIATALabel.text = flight.arrivalAirport.code
        cell.arrivalTimeLabel.text = DateFormatter.timeFormatter.string(from: flight.arrivalDate)
        cell.delegate = self
        cell.tag = indexPath.section

        return cell
    }
}

extension FlightSearchResultViewController: FlightCellDelegate {
    func flightCellDidAddFlight(_ cell: FlightCell) {
        let flight = flights![cell.tag]

        delegate?.flightSearchResultViewController(self, didSelect: flight)
    }
}
