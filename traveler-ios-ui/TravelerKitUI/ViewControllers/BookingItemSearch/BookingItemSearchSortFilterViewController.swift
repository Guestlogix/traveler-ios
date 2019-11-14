//
//  BookingItemSearchSortFilterViewController.swift
//  TravelerKitUI
//
//  Created by Rakin Hoque on 2019-11-12.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

public protocol BookingItemSearchSortFilterViewControllerDelegate: class {
    func bookingItemSearchSortFilterController(_ controller: BookingItemSearchSortFilterViewController, didFinishWith query: BookingItemQuery)
}

open class BookingItemSearchSortFilterViewController: UITableViewController {
    private struct Paths {
        static let sort = IndexPath(row: 0, section: 0)
        static let price = IndexPath(row: 0, section: 1)
    }

    public weak var delegate: BookingItemSearchSortFilterViewControllerDelegate?
    
    public var currentSearchFacets: Facets?
    public var initialSearchFacets: Facets?
    public var searchQuery: BookingItemQuery?
    
    private var currentPriceRange: ClosedRange<Double>?
    private var fullPriceRange: ClosedRange<Double> {
        if let minFacetsPrice = initialSearchFacets?.minPrice.valueInBaseCurrency, let maxFacetsPrice = initialSearchFacets?.maxPrice.valueInBaseCurrency, minFacetsPrice <= maxFacetsPrice {
            return minFacetsPrice...maxFacetsPrice
        } else {
            return 1...1000
        }
    }
    
    private var currentSort: ProductItemSort?
    private var defaultSort: ProductItemSort {
        if let query = searchQuery, let sortOrder = query.sortOrder, let sortOption = query.sortOption {
            switch (sortOption, sortOrder) {
            case (.price, .ascending):
                return .priceAscending
            case (.price, .descending):
                return .priceDescending
            case (.title, .ascending):
                return .titleAscending
            case(.title, .descending):
                return .titleDescending
            }
        } else {
            return .priceAscending
        }
    }
        
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "SelectOptionCell", bundle: Bundle(for: BookingItemSearchSortFilterViewController.self)), forCellReuseIdentifier: CellIdentifiers.bookingItemSearchSortFilter)
        
        resetData()
    }
    
    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case ("sortSegue", let navVC as UINavigationController):
            let vc = navVC.topViewController as? BookingItemSearchSortViewController
            vc?.delegate = self
            vc?.currentSelection = currentSort!
        case ("filterPriceSegue", let navVC as UINavigationController):
            let vc = navVC.topViewController as? BookingItemSearchFilterPriceViewController
            vc?.delegate = self
            vc?.currentRange = currentPriceRange
            vc?.fullRange = fullPriceRange
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }
    
    @IBAction func didCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didSubmit() {
        guard let currentSearchFacets = currentSearchFacets, searchQuery != nil else {
            didCancel()
            return
        }
        
        var bookingItemSearchFilters = BookingItemSearchFilters()
        bookingItemSearchFilters.priceRange = PriceRangeFilter(range: currentPriceRange!, currency: currentSearchFacets.minPrice.baseCurrency)
        bookingItemSearchFilters.categories = searchQuery!.categories
        bookingItemSearchFilters.city = searchQuery!.city
        bookingItemSearchFilters.country = searchQuery!.country
        bookingItemSearchFilters.sortOption = currentSort!.option
        bookingItemSearchFilters.sortOrder = currentSort!.order
        searchQuery = searchQuery!.filterSearchWith(bookingItemSearchFilters)
        delegate?.bookingItemSearchSortFilterController(self, didFinishWith: searchQuery!)
        
        dismiss(animated: true, completion: nil)
    }
    
    func resetData() {
        currentSort = defaultSort
        
        if let minFacetsPrice = currentSearchFacets?.minPrice.valueInBaseCurrency, let maxFacetsPrice = currentSearchFacets?.maxPrice.valueInBaseCurrency, minFacetsPrice <= maxFacetsPrice {
            currentPriceRange = minFacetsPrice...maxFacetsPrice
        } else {
            currentPriceRange = fullPriceRange
        }
    }
    
    @IBAction func didReset() {
        resetData()
        tableView.reloadData()
    }
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 1
        default:
            Log("Unhandled number of rows for section; this should not happen!", data: section, level: .error)
            return 0
        }
    }
    
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Sort"
        case 1:
            return "Filters"
        default:
            Log("Unhandled title for section; this should not happen!", data: section, level: .error)
            return ""
        }
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.bookingItemSearchSortFilter, for: indexPath) as! SelectOptionCell
        cell.selectionStyle = .none
        
        switch indexPath {
        case Paths.sort:
            cell.titleLabel.text = "Order by"
            cell.optionLabel.text = currentSort!.rowInformation.title
        case Paths.price:
            cell.titleLabel.text = "Price"
            cell.optionLabel.text = String(format: "$%.2f - $%.2f", currentPriceRange!.lowerBound, currentPriceRange!.upperBound)
        default:
            Log("Unhandled sort/filter option for row.", data: indexPath, level: .error)
        }
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case Paths.sort:
            performSegue(withIdentifier: "sortSegue", sender: self)
        case Paths.price:
            performSegue(withIdentifier: "filterPriceSegue", sender: self)
        default:
            Log("Unhandled sort/filter option for row.", data: indexPath, level: .error)
        }
    }
}

extension BookingItemSearchSortFilterViewController: BookingItemSearchSortViewControllerDelegate {
    public func bookingItemSearchSortViewController(_ controller: BookingItemSearchSortViewController, didFinishWith sortOption: ProductItemSort) {
        currentSort = sortOption
        tableView.reloadRows(at: [Paths.sort], with: .automatic)
    }
}

extension BookingItemSearchSortFilterViewController: BookingItemSearchFilterPriceViewControllerDelegate {
    public func bookingItemSearchFilterPriceController(_ controller: BookingItemSearchFilterPriceViewController, didFinishWith priceRange: ClosedRange<Double>) {
        currentPriceRange = priceRange
        tableView.reloadRows(at: [Paths.price], with: .automatic)
    }
}
