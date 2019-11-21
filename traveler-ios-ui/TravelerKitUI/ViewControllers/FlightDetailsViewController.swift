//
//  FlightDetailsViewController.swift
//  TravelerKitUI
//
//  Created by Rakin Hoque on 2019-11-29.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

open class FlightDetailsViewController: UITableViewController {
    private let startToFinishCellIdentifier = "startToFinish"
    private let pairedDetailCell = "pairedDetail"
    
    public var flight: Flight?
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "StartToFinishCell", bundle: Bundle(for: FlightDetailsViewController.self)), forCellReuseIdentifier: startToFinishCellIdentifier)
        tableView.register(UINib(nibName: "PairedDetailCell", bundle: Bundle(for: FlightDetailsViewController.self)), forCellReuseIdentifier: pairedDetailCell)
    }
    
    @IBAction func didCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: startToFinishCellIdentifier, for: indexPath) as! StartToFinishCell
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM dd • hh:mma"
            
            cell.selectionStyle = .none
            
            let airplane = UIBezierPath(airplane: cell.icon.bounds)
            let airplaneLayer = CAShapeLayer()
            airplaneLayer.path = airplane.cgPath
            cell.icon.layer.addSublayer(airplaneLayer)
            
            cell.startTopLabel.text = "\(flight!.departureAirport.city), \(flight!.departureAirport.countryCode)"
            cell.startMiddleLabel.text = flight?.departureAirport.code
            cell.startBottomLabel.text = flight?.departureDateDescription(with: dateFormatter)
            
            cell.EndTopLabel.text = "\(flight!.arrivalAirport.city), \(flight!.arrivalAirport.countryCode)"
            cell.EndMiddleLabel.text = flight?.arrivalAirport.code
            cell.EndBottomLabel.text = flight?.arrivalDateDescription(with: dateFormatter)
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: pairedDetailCell, for: indexPath) as! PairedDetailCell
            let boardingDateFormatter = DateFormatter()
            boardingDateFormatter.dateFormat = "'Boarding at 'hh:mma"
            let flightDateFormatter = DateFormatter()
            flightDateFormatter.dateFormat = "MMM dd, yyyy' at 'hh:mma' (local)'"
            
            cell.selectionStyle = .none
            
            cell.titleLabel?.text = "Flight \(flight!.number)"
            cell.secondaryTitleLeftLabel.text = flight?.departureDateDescription(with: boardingDateFormatter)
            
            if let departingTerminal = flight?.departureTerminal {
                cell.secondaryTitleRightLabel.text = "Terminal \(departingTerminal)"
            } else {
                cell.secondaryTitleRightLabel.text = ""
            }
            
            cell.detailOnePrimaryLabel.text = "Departing \(flight!.departureDateDescription(with: flightDateFormatter))"
            cell.detailOneSecondaryLabel.text = "\(flight!.departureAirport.name) (\(flight!.departureAirport.code))"
            cell.detailOneTertiaryLabel.text = "\(flight!.departureAirport.city), \(flight!.departureAirport.country)"
            
            cell.detailTwoPrimaryLabel.text = "Arriving \(flight!.arrivalDateDescription(with: flightDateFormatter))"
            cell.detailTwoSecondaryLabel.text = "\(flight!.arrivalAirport.name) (\(flight!.arrivalAirport.code))"
            cell.detailTwoTertiaryLabel.text = "\(flight!.arrivalAirport.city), \(flight!.arrivalAirport.country)"
            
            return cell
        }
    }
}
