//
//  FlightCell.swift
//  Passenger
//
//  Created by Ata Namvari on 2018-10-17.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import UIKit

protocol FlightCellDelegate: class {
    func flightCellDidAddFlight(_ cell: FlightCell)
}

class FlightCell: UITableViewCell {
    @IBOutlet weak var departureCityLabel: UILabel!
    @IBOutlet weak var arrivalCityLabel: UILabel!
    @IBOutlet weak var departureIATALabel: UILabel!
    @IBOutlet weak var arrivalIATALabel: UILabel!
    @IBOutlet weak var departureTimeLabel: UILabel!
    @IBOutlet weak var arrivalTimeLabel: UILabel!

    weak var delegate: FlightCellDelegate?

    @IBAction func didAddFlight(_ sender: UIButton) {
        delegate?.flightCellDidAddFlight(self)
    }
}
