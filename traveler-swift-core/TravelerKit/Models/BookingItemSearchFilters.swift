//
//  BookingItemSearchFilters.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-09-15.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/**
 A model representing different ways in which the items in `BookingItemSearchResult` can be filtered
 */
public struct BookingItemSearchFilters {
    /// Keywords
    public var text: String?
    // TODO: `ProductItemCategory` should be refactored
    /// Item category
    public var categories: [BookingItemCategory]?
    /// Range of prices for items
    public var priceRange: PriceRangeFilter?
    /// Range of availability dates for items
    public var dateRange: DateRangeFilter?
    /// Item country
    public var country: String?
    /// Item city
    public var city: String?
    /// Sort by
    public var sortOption: ProductItemSortOption?
    /// Sort order
    public var sortOrder: ProductItemSortOrder?

    public init() {}
}
