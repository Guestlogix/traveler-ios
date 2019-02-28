//
//  FlightSearchResultViewController.swift
//  Passenger
//
//  Created by Ata Namvari on 2018-10-17.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import UIKit
import TravelerKit

protocol FlightSearchResultViewControllerDelegate: class {
    func flightSearchResultViewController(_ controller: FlightSearchResultViewController, didSelect flight: Flight)
    func flightSearchResultViewControllerCanAdd(_ controller: FlightSearchResultViewController, flight: Flight) -> Bool
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
        let canAddFlight = delegate?.flightSearchResultViewControllerCanAdd(self, flight: flight)

        cell.departureCityLabel.text = flight.departureAirport.city
        cell.departureIATALabel.text = flight.departureAirport.code
        cell.departureTimeLabel.text = DateFormatter.timeFormatter.string(from: flight.departureDate)
        cell.arrivalCityLabel.text = flight.arrivalAirport.city
        cell.arrivalIATALabel.text = flight.arrivalAirport.code
        cell.arrivalTimeLabel.text = DateFormatter.timeFormatter.string(from: flight.arrivalDate)
        cell.addFlightButton.setTitle("Flight Added", for: .disabled)
        cell.addFlightButton.setTitle("Add Flight", for: .normal)
        cell.delegate = self
        cell.tag = indexPath.section
        
        
        switch(canAddFlight) {
        case(false):
            cell.addFlightButton.isEnabled = true
        
        default:
            cell.addFlightButton.isEnabled = false
        }
        
            return cell
    }
}

extension FlightSearchResultViewController: FlightCellDelegate {
    func flightCellDidAddFlight(_ cell: FlightCell) {
        let flight = flights![cell.tag]

        delegate?.flightSearchResultViewController(self, didSelect: flight)
    }
}
