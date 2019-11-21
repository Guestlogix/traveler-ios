//
//  ItineraryViewController.swift
//  TravelerKitUI
//
//  Created by Rakin Hoque on 2019-11-21.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

open class ItineraryViewController: UIViewController {
    public var flights: [Flight] = []
    
    private var itinerary = ItineraryByDay()
    private var currentItinerary = ItineraryByDay()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        reload()
    }
    
    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let loadingVC as LoadingViewController):
            loadingVC.loadingTitleString = "Loading itinerary..."
        case ("emptySegue", let emptyVC as ErrorViewController):
            emptyVC.delegate = self
            emptyVC.errorTitleString = "Your itinerary is empty"
            emptyVC.errorMessageString = ""
            emptyVC.actionButtonString = "Filters"
        case (_, let resultVC as ItineraryResultViewController):
            resultVC.delegate = self
            resultVC.itinerary = currentItinerary
            resultVC.flights = flights
        case ("filterSegue", let navVC as UINavigationController):
            let vc = navVC.topViewController as? ItineraryFilterViewController
            vc?.delegate = self
            vc?.dateRange = currentItinerary.dateRange ?? Date()...Date()
            vc?.types = itinerary.types
            vc?.selectedTypes = currentItinerary.types
        case ("errorSegue", _):
            break
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }
    
    @IBAction func didCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func reload(with dateRange: ClosedRange<Date>? = nil) {
        let query = ItineraryQuery(flights: flights, dateRange: dateRange)
        
        performSegue(withIdentifier: "loadingSegue", sender: nil)
        
        Traveler.fetchItinerary(query, delegate: self)
    }
    
    func filter() {
        performSegue(withIdentifier: "loadingSegue", sender: nil)
        
        currentItinerary = itinerary.filteredItinerary(by: currentItinerary.dateRange, types: currentItinerary.types)
        
        if currentItinerary.daysAvailable.count > 0 {
            performSegue(withIdentifier: "resultSegue", sender: nil)
        } else {
            performSegue(withIdentifier: "emptySegue", sender: nil)
        }
    }
}

extension ItineraryViewController: ItineraryResultViewControllerDelegate {
    public func itineraryResultViewControllerShouldPresentFilter(_ controller: ItineraryResultViewController) {
        performSegue(withIdentifier: "filterSegue", sender: nil)
    }
}

extension ItineraryViewController: ErrorViewControllerDelegate {
    public func errorViewControllerDidRetry(_ controller: ErrorViewController) {
        performSegue(withIdentifier: "filterSegue", sender: nil)
    }
}

extension ItineraryViewController: ItineraryFilterViewControllerDelegate {
    public func itineraryFilterViewControllerDidApplyFilters(_ controller: ItineraryFilterViewController, types: [ItineraryItemType], dateRange: ClosedRange<Date>) {
        let newMin = dateRange.lowerBound.minTimeOfDay()
        let newMax = dateRange.upperBound.maxTimeOfDay()
        
        currentItinerary.dateRange = newMin...newMax
        currentItinerary.types = types
        
        if let fullMin = itinerary.dateRange?.lowerBound.minTimeOfDay(), let fullMax = itinerary.dateRange?.upperBound.maxTimeOfDay() {
            if newMin < fullMin || newMax > fullMax {
                reload(with: newMin...newMax)
            } else {
                filter()
            }
        } else {
            reload(with: newMin...newMax)
        }
    }
}

extension ItineraryViewController: ItineraryFetchDelegate {
    public func itineraryFetchDidSucceedWith(_ result: ItineraryResult) {
        itinerary = ItineraryByDay(result, currentDateRange: currentItinerary.dateRange)
        
        if itinerary.itemsByDay.count > 0 {
            filter()
        } else {
            performSegue(withIdentifier: "emptySegue", sender: nil)
        }
    }
    
    public func itineraryFetchDidFailWith(_ error: Error) {
        performSegue(withIdentifier: "errorSegue", sender: nil)
    }
}
