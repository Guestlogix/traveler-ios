//
//  BookingItemSearchViewController.swift
//  Traveler
//
//  Created by Omar Padierna on 2019-08-07.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

open class BookingItemSearchViewController: UIViewController {
    private var initialBookingItemResult: BookingItemSearchResult?
    private var currentBookingItemResult: BookingItemSearchResult?
    
    public var searchQuery: BookingItemQuery?

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        guard let searchQuery = searchQuery else {
            Log("No BookingItemQuery provided", data: nil, level: .error)
            return
        }

        Traveler.searchBookingItems(searchQuery, identifier: nil, delegate: self)
        performSegue(withIdentifier: "loadingSegue", sender: nil)
    }

    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case ("loadingSegue", _), ("errorSegue", _):
            break
        case ("bookingItemSearchSortFilterSegue" , let navVC as UINavigationController):
            let searchSortFilterVC = navVC.topViewController as? BookingItemSearchSortFilterViewController
            searchSortFilterVC?.delegate = self
            searchSortFilterVC?.initialSearchFacets = initialBookingItemResult?.facets
            searchSortFilterVC?.currentSearchFacets = currentBookingItemResult?.facets
            searchSortFilterVC?.searchQuery = searchQuery
        case (_ , let searchResultsVC as BookingItemSearchResultViewController):
            searchResultsVC.bookingItemResult = currentBookingItemResult
            searchResultsVC.searchQuery = searchQuery
        default:
            Log("Unknown segue", data: nil, level: .warning)
        }
    }

    @IBAction func didPressCancel(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension BookingItemSearchViewController: BookingItemSearchSortFilterViewControllerDelegate {
    public func bookingItemSearchSortFilterController(_ controller: BookingItemSearchSortFilterViewController, didFinishWith query: BookingItemQuery) {
        searchQuery = query
        Traveler.searchBookingItems(query, identifier: nil, delegate: self)
        performSegue(withIdentifier: "loadingSegue", sender: nil)
    }
}

extension BookingItemSearchViewController: BookingItemSearchDelegate {
    public func bookingItemSearchDidSucceedWith(_ result: BookingItemSearchResult, identifier: AnyHashable?) {
        if initialBookingItemResult == nil {
            initialBookingItemResult = result
        }
        currentBookingItemResult = result
        performSegue(withIdentifier: "searchResultSegue", sender: nil)
    }

    public func bookingItemSearchDidFailWith(_ error: Error, identifier: AnyHashable?) {
        performSegue(withIdentifier: "errorSegue", sender: nil)
    }
}
