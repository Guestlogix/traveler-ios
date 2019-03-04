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

class FlightDetailsViewController: UIViewController {
    @IBOutlet weak var departureCityLabel: UILabel!
    @IBOutlet weak var arrivalCityLabel: UILabel!
    @IBOutlet weak var departureIATALabel: UILabel!
    @IBOutlet weak var arrivalIATALabel: UILabel!
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!
    @IBOutlet weak var flightNumberLabel: UILabel!
    @IBOutlet weak var flightDateLabel: UILabel!
    
    var flights: [Flight]?
    
    override func viewDidLoad() {
        
        let flight = flights![0]
        
        departureCityLabel.text = flight.departureAirport.city
        departureIATALabel.text = flight.departureAirport.code
        departureTimeLabel.text = DateFormatter.timeFormatter.string(from: flight.departureDate)
        arrivalCityLabel.text = flight.arrivalAirport.city
        arrivalIATALabel.text = flight.arrivalAirport.code
        arrivalTimeLabel.text = DateFormatter.timeFormatter.string(from: flight.arrivalDate)
        
        flightNumberLabel.text = flight.number
        flightDateLabel.text = DateFormatter.longFormatter.string(for: flight.departureDate)
        flightNumberLabel.textColor = .white
        flightDateLabel.textColor = .white
    }


}
