//
//  CatalogItemSearchQuery.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-08-07.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// A general all encompassing search query
public struct CatalogItemSearchQuery {
    /// Pagination offset
    public let offset: Int
    /// Pagination limit
    public let limit: Int
    /// Text for text-based queries
    public let text: String?
    /// Minimum allowed price for items
    public let range: PriceRange?
    /// Item category
    public let categories: [CatalogItemCategory]?
    /// A `BoundingBox` representing the geographic area in which items should be searched for
    public let boundingBox: BoundingBox?

    /**
     Initializes a `CatalogItemSearchQuery`

     - Parameters:
     - An `Int` for pagination offset
     - An `Int` for page size
     - An optional `String` for text queries
     - An optional `PriceRange`
     - An optional `Array<Category>` for categories
     - An optional `BoundingBox`
     - An optiona `String` for city
     - Returns: `CatalogItemSearchQuery`
     */

    public init(offset: Int = 0, take: Int = 10, text: String?, range: PriceRange?, categories: [CatalogItemCategory]?,  boundingBox: BoundingBox?) {
        self.offset = offset
        self.limit = take
        self.text = text
        self.range = range
        self.categories = categories
        self.boundingBox = boundingBox
    }

    init(with params: CatalogItemSearchParameters) {
        self.boundingBox = params.boundingBox
        self.categories = params.categories
        self.range = params.range
        self.text = params.text
        self.offset = 0
        self.limit = 10
    }

    /**
     Implementes filters into  a `CatalogItemSearchQuery`

     - Parameters:
     - A `CatalogItemSearchFilters` thay contains the filters that are to be applied to the original query
     - Returns: `CatalogItemSearchQuery`
     */

    public func filterSearchWith(_ filters: CatalogItemSearchFilters) -> CatalogItemSearchQuery {
        return CatalogItemSearchQuery(text: self.text, range: filters.priceRange, categories: filters.categories, boundingBox: self.boundingBox)
    }
}

extension CatalogItemSearchQuery: Equatable {
    public static func == (lhs: CatalogItemSearchQuery, rhs: CatalogItemSearchQuery) -> Bool {
        var categoriesBool = false

        switch (lhs.categories, rhs.categories) {
        case (.some, .some):
            categoriesBool = lhs.categories!.elementsEqual(rhs.categories!)
        case (.none, .none):
            categoriesBool = true
        default:
            categoriesBool = false
        }

        return lhs.boundingBox == rhs.boundingBox && categoriesBool && lhs.range == rhs.range
    }
}
