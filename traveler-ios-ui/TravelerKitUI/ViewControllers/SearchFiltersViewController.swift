//
//  SearchFiltersViewController.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-09-06.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

protocol SearchFiltersViewControllerDelegate {
    func searchFiltersViewControllerWillFilterWith(_ filters: CatalogItemSearchFilters, controller: SearchFiltersViewController)
}

class SearchFiltersViewController: UIViewController {

    @IBOutlet weak var sortControl: UISegmentedControl!
    @IBOutlet weak var filtersTableView: UITableView!

    public var delegate: SearchFiltersViewControllerDelegate?
    public var previousfilters: CatalogItemSearchFilters?

    var facets: Facets?

    private var selectedCategories: [CatalogItemCategory]?
    private var filters = CatalogItemSearchFilters()
    private var minPrice: Price?
    private var maxPrice: Price?

    override func viewDidLoad() {
        super.viewDidLoad()
        let bundle = Bundle(for: type(of: self))
        filtersTableView.dataSource = self
        filtersTableView.rowHeight = UITableView.automaticDimension
        filtersTableView.register(UINib(nibName: "TagsCell", bundle: bundle), forCellReuseIdentifier: "categoryCell")
        filtersTableView.register(UINib(nibName: "RangeCell", bundle: bundle), forCellReuseIdentifier: "pricesCell")
        filtersTableView.separatorStyle = .none
    }

    @IBAction func didClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didClear(_ sender: Any) {
        previousfilters = nil
        filtersTableView.reloadData()
    }

    @IBAction func didFilter(_ sender: Any) {

        var finalFilters = CatalogItemSearchFilters()

        switch (filters.categories, previousfilters?.categories) {
        case (.some, _):
            finalFilters.categories = filters.categories
        case (.none, .none):
            break
        case (.none, .some):
            finalFilters.categories = previousfilters?.categories
        }

        switch (filters.priceRange, previousfilters?.priceRange) {
        case (.some, _):
            finalFilters.priceRange = filters.priceRange
        case (.none, .some):
            finalFilters.priceRange = previousfilters?.priceRange
        case (.none, .none):
            break
        }

        delegate?.searchFiltersViewControllerWillFilterWith(finalFilters, controller: self)
        dismiss(animated: true, completion: nil)
    }
}

extension SearchFiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return facets?.availableFacets.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let facet = facets?.availableFacets[indexPath.row] else {
            return UITableViewCell()
        }

        switch facet {
        case .category:

            let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath) as! TagsCell
            cell.tagTitles = []
            cell.tagTitles = facets!.categories.map({ $0.category.rawValue })

            if let selectedCategories = previousfilters?.categories {
                cell.selectedTiles = selectedCategories.map({ $0.rawValue })
            }

            cell.delegate = self
            cell.titleLabel.text = "Categories"
            return cell
        case .prices:
            let cell = tableView.dequeueReusableCell(withIdentifier: "pricesCell", for: indexPath) as! RangeCell

            let minPrice = facets!.minPrice
            let maxPrice = facets!.maxPrice

            cell.minValue = minPrice.valueInBaseCurrency
            cell.maxValue = maxPrice.valueInBaseCurrency
            cell.minValueLabel.text = minPrice.localizedDescriptionInBaseCurrency
            cell.maxValueLabel.text = maxPrice.localizedDescriptionInBaseCurrency
            cell.titleLabel.text = "Price Range"
            cell.predeterminedUpperBound = maxPrice.valueInBaseCurrency
            cell.predeterminedLowerBound = minPrice.valueInBaseCurrency

            if let priceRange = previousfilters?.priceRange {
                cell.predeterminedUpperBound = priceRange.range.upperBound
                cell.predeterminedLowerBound = priceRange.range.lowerBound

                let lowerPrice = Price(floatLiteral: priceRange.range.lowerBound)
                let higherPrice = Price(floatLiteral: priceRange.range.upperBound)

                cell.maxValueLabel.text = higherPrice.localizedDescriptionInBaseCurrency
                cell.minValueLabel.text = lowerPrice.localizedDescriptionInBaseCurrency
            } 

            cell.delegate = self

            return cell
        }
    }
}

extension SearchFiltersViewController: TagsCellDelegate {
    func selectedTags(_ titles: [String]) {
        selectedCategories = titles.map({ CatalogItemCategory(rawValue: $0)! })
        filters.categories = selectedCategories
    }
}

extension SearchFiltersViewController: RangeCellDelegate {
    func valueDidChangeFor(_ rangeCell: RangeCell) {
        minPrice = Price(floatLiteral: rangeCell.lowerBound!)
        maxPrice = Price(floatLiteral: rangeCell.upperBound!)

        let range = minPrice!.valueInBaseCurrency...maxPrice!.valueInBaseCurrency
        let currency = minPrice!.baseCurrency
        let priceRange = PriceRange(range: range, currency: currency)

        filters.priceRange = priceRange
    }

    func updateLabelsFor(_ rangeCell: RangeCell) {
        rangeCell.maxValueLabel.text = maxPrice?.localizedDescriptionInBaseCurrency
        rangeCell.minValueLabel.text = minPrice?.localizedDescriptionInBaseCurrency
    }
}
