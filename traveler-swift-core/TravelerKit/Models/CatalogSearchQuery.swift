//
//  CatalogSearchQuery.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-08-07.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// A general all encompassing search query
public protocol SearchQuery {
    /// Text for text-based queries
    var text: String? { get }
    /// Minimum allowed price for products
    var minPrice: Double? { get }
    /// Maximum allowed price for products
    var maxPrice: Double? { get }
    /// Product category
    var categories: [Category]? { get }
    /// Latitude belonging to the top left corner of bounding box
    var topLeftLatitude: Double? { get }
    /// Longitude belonging to the top left corner of bounding box
    var topLeftLongitude: Double? { get }
    /// Latitude belonging to the bottom right corner of bounding box
    var bottomRightLatitude: Double? { get }
    /// Longitude belonging to the bottom right corner of bounding box
    var bottomRightLongitude: Double? { get }
}

/// A geographic specific search. Init requires all coordinates to be implemented.
public protocol GeoSearch: SearchQuery {
    init(text: String?, minPrice: Double?, maxPrice: Double?, categories: [Category]?, topLeftLatitude: Double, topLeftLongitude: Double, bottomRightLatitude: Double, bottomRightLongitude: Double)
}

/**
 This type is used to retrieve a `Catalog` filtered by this type's attributes
 */

public struct CatalogSearchQuery: SearchQuery {

    public let text: String?
    public let minPrice: Double?
    public let maxPrice: Double?
    public let categories: [Category]?

    /**
     Initializes a `CatalogSearchQuery`, init will return nil if all attributes are nil.

     - Parameters:
     - text: An optional `String`
     - minPrice: An optional `Double`
     - maxPrice: An optional `Double`
     - categories: An optional `Category` array

     - Returns: An optional `CatalogSearchQuery`
     */

    public init?(text: String?, minPrice: Double?, maxPrice: Double?, categories: [Category]?) {
        if text == nil && minPrice == nil && maxPrice == nil && categories == nil {
            Log("CatalogSearchQuery must contain at least one of the following: text, category, minPrice or maxPrice", data: nil, level: .warning)
            return nil
        }

        self.text = text
        self.minPrice = minPrice
        self.maxPrice = maxPrice
        self.categories = categories
    }
}

/**
 This type is used to retrieve a `Catalog` filtered by this type's attributes and location represented with a bounding box.
 */

public struct CatalogGeoSearchQuery: GeoSearch {

    public let topLeftLatitude: Double?
    public let topLeftLongitude: Double?
    public let bottomRightLatitude: Double?
    public let bottomRightLongitude: Double?
    public let text: String?
    public let minPrice: Double?
    public let maxPrice: Double?
    public let categories: [Category]?

    /**
     Initializes a `CatalogGeoSearchQuery`

     - Parameters:
     - text: An optional `String`
     - minPrice: An optional `Double`
     - maxPrice: An optional `Double`
     - categories: An optional `Category` array
     - topLeftLatitude: A `Double` representing the latitude of the top left corner in a bounding box
     - topLeftLongitude: A `Double` representing the longitude of the top left corner in a bounding box
     - bottomRightLatitude: A `Double` representing the latitude of the bottom right corner in a bounding box
     - bottomRightLongitude: A `Double` representing the longitude of the bottom right corner in a bounding box
     - Returns: A `CatalogGeoSearchQuery`
     */

    public init(text: String?, minPrice: Double?, maxPrice: Double?, categories: [Category]?, topLeftLatitude: Double, topLeftLongitude: Double, bottomRightLatitude: Double, bottomRightLongitude: Double) {

        self.text = text
        self.minPrice = minPrice
        self.maxPrice = maxPrice
        self.categories = categories
        self.topLeftLongitude = topLeftLongitude
        self.topLeftLatitude = topLeftLatitude
        self.bottomRightLatitude = bottomRightLatitude
        self.bottomRightLongitude = bottomRightLongitude
    }
}

extension SearchQuery {
    public var topLeftLatitude: Double? {
        get { return nil }
    }
    public var topLeftLongitude: Double? {
        get { return nil }
    }
    public var bottomRightLatitude: Double? {
        get { return nil }
    }
    public var bottomRightLongitude: Double? {
        get { return nil }
    }
}
