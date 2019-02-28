//
//  FlightDetailsViewController.swift
//  Traveler
//
//  Created by Dorothy Fu on 2019-02-28.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit


let flightCellInfoIdentifier = "flightCellIdentifier"

class FlightDetailsViewController: UITableViewController {
    var flights: [Flight]?
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return flights?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: flightCellInfoIdentifier, for: indexPath) as! FlightCell
        let flight = flights![indexPath.section]
        
        cell.departureCityLabel.text = flight.departureAirport.city
        cell.departureIATALabel.text = flight.departureAirport.code
        cell.departureTimeLabel.text = DateFormatter.timeFormatter.string(from: flight.departureDate)
        cell.arrivalCityLabel.text = flight.arrivalAirport.city
        cell.arrivalIATALabel.text = flight.arrivalAirport.code
        cell.arrivalTimeLabel.text = DateFormatter.timeFormatter.string(from: flight.arrivalDate)
        cell.tag = indexPath.section
        
        return cell
    }
}
