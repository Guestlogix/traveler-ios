//
//  BookingItemSearchViewController.swift
//  Traveler
//
//  Created by Omar Padierna on 2019-08-07.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit


open class BookingItemQueryViewController: UIViewController {

    private var searchText: String?
    private var bookingItemResult: BookingItemSearchResult?
    private var searchQuery: BookingItemQuery?
    private var facets: Facets?
    private var previousFilters: BookingItemSearchFilters?

    override open func viewDidLoad() {
        super.viewDidLoad()

        let searchBar = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchBar
        searchBar.searchBar.delegate = self
        self.navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }

    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case ("loadingSegue", _), ("errorSegue", _):
            break
        case (_ , let searchResultsVC as BookingItemSearchResultViewController):
            searchResultsVC.bookingItemResult = bookingItemResult
            searchResultsVC.searchQuery = searchQuery
        default:
            Log("Unknown segue", data: nil, level: .warning)
        }
    }

    @IBAction func didPressCancel(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}


extension BookingItemQueryViewController: UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }

        searchQuery = BookingItemQuery(text: searchText, range: nil, boundingBox: nil)
        Traveler.searchBookingItems(searchQuery!, identifier: nil, delegate: self)
        performSegue(withIdentifier: "loadingSegue", sender: nil)
    }
}

extension BookingItemQueryViewController: BookingItemSearchDelegate {
    public func bookingItemSearchDidSucceedWith(_ result: BookingItemSearchResult, identifier: AnyHashable?) {
        switch (facets) {
            case .none:
                facets = result.facets
            default:
                break
        }
        bookingItemResult = result
        self.navigationItem.searchController?.isActive = false
        performSegue(withIdentifier: "searchResultSegue", sender: nil)
    }

    public func bookingItemSearchDidFailWith(_ error: Error, identifier: AnyHashable?) {
        self.navigationItem.searchController?.isActive = false
        performSegue(withIdentifier: "errorSegue", sender: nil)
    }
}
