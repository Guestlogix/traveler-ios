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
    /// Item category
    public var categories: [ProductItemCategory]?
    ///  Range of prices for items
    public var priceRange: PriceRangeFilter?

    public init() {}
}
