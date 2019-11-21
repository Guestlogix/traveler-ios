//
//  ItineraryResultViewController.swift
//  TravelerKitUI
//
//  Created by Rakin Hoque on 2019-11-21.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

public protocol ItineraryResultViewControllerDelegate: class {
    func itineraryResultViewControllerShouldPresentFilter(_ controller: ItineraryResultViewController)
}

open class ItineraryResultViewController: UITableViewController {
    private let cellIdentifier = "ItineraryItemCell"
    
    public weak var delegate: ItineraryResultViewControllerDelegate?
    
    public var flights = [Flight]()
    public var itinerary = ItineraryByDay()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ItineraryItemCell", bundle: Bundle(for: ItineraryViewController.self)), forCellReuseIdentifier: cellIdentifier)
    }
    
    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination, sender) {
        case ("flightDetailsSegue", let navVC as UINavigationController, let flight as Flight):
            let vc  = navVC.topViewController as? FlightDetailsViewController
            vc?.flight = flight
        case ("purchasedProductSegue", let navVC as UINavigationController, let query as PurchasedProductDetailsQuery):
            let vc = navVC.topViewController as? PurchasedProductDetailViewController
            vc?.query = query
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }
    
    @IBAction func didPressFilters() {
        delegate?.itineraryResultViewControllerShouldPresentFilter(self)
    }
    
    override open func numberOfSections(in tableView: UITableView) -> Int {
        return itinerary.daysAvailable.count
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itinerary.itemsByDay[itinerary.daysAvailable[section]]?.count ?? 0
    }
    
    override open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, d MMM yyyy"
        return formatter.string(from: itinerary.daysAvailable[section])
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! ItineraryItemCell
        let cellData = itinerary.itemsByDay[itinerary.daysAvailable[indexPath.section]]![indexPath.row]
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mma"
        
        cell.selectionStyle = .none
        cell.titleLabel.text = cellData.title
        cell.secondaryTitleLabel.text = cellData.subTitle
        
        if cellData.isAllDay {
            cell.tertiaryTitleLabel.text = ""
        } else {
            cell.tertiaryTitleLabel.text = formatter.string(from: cellData.startDate)
        }
        
        if let url = cellData.thumbnailURL {
            AssetManager.shared.loadImage(with: url) { [weak cell] (image) in
                cell?.icon.image = image
            }
        }
        
        return cell
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = itinerary.itemsByDay[itinerary.daysAvailable[indexPath.section]]![indexPath.row]
        
        if let purchaseType = item.type.purchaseType {
            let query = PurchasedProductDetailsQuery(orderId: item.orderId!, productId: item.id, purchaseType: purchaseType)
            
            self.performSegue(withIdentifier: "purchasedProductSegue", sender: query)
        } else if item.type == .flight {
            let currentFlight = flights.filter { $0.id == item.id }.first
            
            if let currentFlight = currentFlight {
                self.performSegue(withIdentifier: "flightDetailsSegue", sender: currentFlight)
            }
        }
    }
}
