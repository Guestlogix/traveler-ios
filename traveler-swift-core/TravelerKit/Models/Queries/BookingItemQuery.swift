//
//  BookingItemQuery.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-09-29.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// A query to fetch Booking items
public struct BookingItemQuery {
    /// Pagination offset
    public let offset: Int
    /// Pagination limit
    public let limit: Int
    /// Text for text-based queries
    public let text: String?
    /// Minimum allowed price for items
    public let priceRange: PriceRangeFilter?
    /// Item category
    public let categories: [BookingItemCategory]
    
    // TODO: Encapsulate boundingBox, country, and city into Location
    /// A `BoundingBox` representing the geographic area in which items should be searched for
    public let boundingBox: BoundingBox?
    /// Item country
    public let country: String?
    /// Item city
    public let city: String?
    /// A coordinate representing the geographic center in which items should be searched for
    public let location: Coordinate?
    
    // TODO: Encapsulate sortOption and sortOrder into Sort
    /// Sort by
    public let sortOption: ProductItemSortOption?
    /// Sort order
    public let sortOrder: ProductItemSortOrder?

    /**
     Initializes a `BookingItemQuery`
     - Parameters:
     - An `Int` for pagination offset
     - An `Int` for page size
     - An optional `String` for text queries
     - An optional `PriceRange`
     - An optional `Array<Category>` for categories
     - An optional `BoundingBox`
     - An optional `String` for country
     - An optional `String` for city
     - An optional `ProductItemSortOption` for sorting by
     - An optional `ProductItemSortOrder` for sorting order
     - Returns: `BookingItemQuery`
     */

    public init(offset: Int = 0, take: Int = 10, text: String?, range: PriceRangeFilter?, categories: [BookingItemCategory] = [] , boundingBox: BoundingBox?, country: String? = nil, city: String? = nil, sortOption: ProductItemSortOption? = nil, sortOrder: ProductItemSortOrder? = nil, location: Coordinate? = nil) {
        self.offset = offset
        self.limit = take
        self.text = text
        self.priceRange = range
        self.categories = categories
        self.boundingBox = boundingBox
        self.country = country
        self.city = city
        self.sortOption = sortOption
        self.sortOrder = sortOrder
        self.location = location
    }

    init(with params: BookingItemSearchParameters) {
        self.boundingBox = params.boundingBox
        self.categories = params.categories
        self.priceRange = params.range
        self.text = params.text
        self.offset = 0
        self.limit = 10
        self.country = params.country
        self.city = params.city
        self.sortOption = params.sortOption
        self.sortOrder = params.sortOrder
        self.location = params.location
    }

    /**
     Implementes filters into  a `BookingItemQuery`

     - Parameters:
     - A `BookingSearchFilters` thay contains the filters that are to be applied to the original query
     - Returns: `BookingItemQuery`
     */

    public func filterSearchWith(_ filters: BookingItemSearchFilters) -> BookingItemQuery {
        return BookingItemQuery(text: filters.text ?? self.text, range: filters.priceRange ?? self.priceRange, categories: filters.categories ?? self.categories, boundingBox: self.boundingBox, country: filters.country ?? self.country, city: filters.city ?? self.city, sortOption: filters.sortOption ?? self.sortOption, sortOrder: filters.sortOrder ?? self.sortOrder, location: self.location)
    }

    func isValid() -> Bool {
        if self.boundingBox == nil && self.priceRange == nil && self.text == nil && self.categories.count == 0 && self.city == nil && self.location == nil {
            return false
        } else {
            return true
        }
    }

}

extension BookingItemQuery: Equatable {
    public static func == (lhs: BookingItemQuery, rhs: BookingItemQuery) -> Bool {
        return lhs.boundingBox == rhs.boundingBox && lhs.priceRange == rhs.priceRange && lhs.text == rhs.text && lhs.categories.elementsEqual(rhs.categories) && lhs.country == rhs.country && lhs.city == rhs.city && lhs.sortOption == rhs.sortOption && lhs.sortOrder == rhs.sortOrder
    }
}
