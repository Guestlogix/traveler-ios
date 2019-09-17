//
//  CatalogItemSearchViewController.swift
//  Traveler
//
//  Created by Omar Padierna on 2019-08-07.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

class CatalogItemSearchViewController: UIViewController {
    @IBOutlet weak var filterButton: UIBarButtonItem!
    
    private var searchText: String?
    private var catalogItemResult: CatalogItemSearchResult?
    private var searchQuery: CatalogItemSearchQuery?
    private var facets: Facets?
    private var previousFilters: CatalogItemSearchFilters?

    override func viewDidLoad() {
        super.viewDidLoad()

        let searchBar = UISearchController(searchResultsController: nil)
        self.navigationItem.searchController = searchBar
        searchBar.searchBar.delegate = self
        self.navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        filterButton.isEnabled = catalogItemResult != nil
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case ("loadingSegue", _):
            break
        case (_ , let searchResultsVC as CatalogItemSearchResultViewController):
            searchResultsVC.catalogItemResult = catalogItemResult
            searchResultsVC.searchQuery = searchQuery
        case ("filterSegue" , let navVC as UINavigationController):
            let filterVC = navVC.topViewController as! SearchFiltersViewController
            filterVC.delegate = self
            filterVC.facets = facets
            filterVC.previousfilters = previousFilters
        default:
            Log("Unknown segue", data: nil, level: .warning)
        }
    }
}

extension CatalogItemSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else {
            return
        }

        searchQuery = CatalogItemSearchQuery(text: searchText, range: nil, categories: nil, boundingBox: nil)
        Traveler.searchCatalog(searchQuery: searchQuery!, identifier: nil, delegate: self)
        performSegue(withIdentifier: "loadingSegue", sender: nil)
    }
}

extension CatalogItemSearchViewController: CatalogItemSearchDelegate {

    func catalogSearchDidSucceedWith(_ result: CatalogItemSearchResult, identifier: AnyHashable?) {
        switch (facets) {
        case .none:
            facets = result.facets
        default:
            break
        }
        catalogItemResult = result
        filterButton.isEnabled = true
        performSegue(withIdentifier: "searchResultSegue", sender: nil)
    }

    func catalogSearchDidFailWith(_ error: Error, identifier: AnyHashable?) {
        performSegue(withIdentifier: "failSegue", sender: nil)
    }
}

extension CatalogItemSearchViewController: SearchFiltersViewControllerDelegate {
    func searchFiltersViewControllerWillFilterWith(_ filters: CatalogItemSearchFilters, controller: SearchFiltersViewController) {
        guard let searchQuery = searchQuery else {
            return
        }
        let filteredQuery = searchQuery.filterSearchWith(filters)
        previousFilters = filters
        Traveler.searchCatalog(searchQuery: filteredQuery, identifier: nil, delegate: self)
        performSegue(withIdentifier: "loadingSegue", sender: nil)
    }
}
