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
    public let categories: [ProductItemCategory]

    /// A `BoundingBox` representing the geographic area in which items should be searched for
    public let boundingBox: BoundingBox?

    /**
     Initializes a `BookingItemQuery`
     - Parameters:
     - An `Int` for pagination offset
     - An `Int` for page size
     - An optional `String` for text queries
     - An optional `PriceRange`
     - An optional `Array<Category>` for categories
     - An optional `BoundingBox`
     - Returns: `BookingItemQuery`
     */


    public init(offset: Int = 0, take: Int = 10, text: String?, range: PriceRangeFilter?, categories: [ProductItemCategory] = [] ,  boundingBox: BoundingBox?) {
        self.offset = offset
        self.limit = take
        self.text = text
        self.priceRange = range
        self.categories = categories
        self.boundingBox = boundingBox
    }

    init(with params: BookingItemSearchParameters) {
        self.boundingBox = params.boundingBox
        self.categories = params.categories ?? []
        self.priceRange = params.range
        self.text = params.text
        self.offset = 0
        self.limit = 10
    }

    /**
     Implementes filters into  a `BookingItemQuery`

     - Parameters:
     - A `BookingSearchFilters` thay contains the filters that are to be applied to the original query
     - Returns: `BookingItemQuery`
     */

    public func filterSearchWith(_ filters: BookingItemSearchFilters) -> BookingItemQuery {
        return BookingItemQuery(text: self.text, range: filters.priceRange, categories: filters.categories ?? [] , boundingBox: self.boundingBox)
    }

    func isValid() -> Bool {
        if self.boundingBox == nil && self.priceRange == nil && self.text == nil && self.categories.count == 0 {
            return false
        } else {
            return true
        }
    }

}

extension BookingItemQuery: Equatable {
    public static func == (lhs: BookingItemQuery, rhs: BookingItemQuery) -> Bool {
        return lhs.boundingBox == rhs.boundingBox && lhs.priceRange == rhs.priceRange && lhs.text == rhs.text && lhs.categories.elementsEqual(rhs.categories)
    }
}
