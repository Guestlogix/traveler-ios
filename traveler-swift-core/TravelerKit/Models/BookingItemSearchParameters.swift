//
//  BookingItemSearchParameters.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-10-04.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation
/// The search parameters that conform to a `BookingQuery`
struct BookingItemSearchParameters: Decodable {
    /// Text for text-based queries
    public let text: String?
    /// Range of prices for items
    public let priceRange: PriceRangeFilter?
    /// Range of availability dates for items
    public let dateRange: DateRangeFilter?
    /// Item category
    public let categories: [BookingItemCategory]
    /// A `BoundingBox`representing the geographic area in which items should be searched for
    public let boundingBox: BoundingBox?
    /// Item country
    public let country: String?
    /// Item city
    public let city: String?
    /// Sort by
    public let sortOption: ProductItemSortOption?
    /// Sort order
    public let sortOrder: ProductItemSortOrder?
    /// Location center
    public let location: Coordinate?

    enum CodingKeys: String, CodingKey {
        case text = "text"
        case topLeftLatitude = "topLeftLatitude"
        case topLeftLongitude = "topLeftLongitude"
        case bottomRightLatitude = "bottomRightLatitude"
        case bottomRightLongitude = "bottomRightLongitude"
        case minPrice = "minPrice"
        case maxPrice = "maxPrice"
        case startDate = "availabilityStart"
        case endDate = "availabilityEnd"
        case currency = "currency"
        case categories = "subCategories"
        case country = "country"
        case city = "city"
        case sortOption = "sortField"
        case sortOrder = "sortOrder"
        case latitude = "latitude"
        case longitude = "longitude"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.text = try container.decode(String?.self, forKey: .text)

        if let mininumPriceValue = try container.decode(Double?.self, forKey: .minPrice),
            let maximumPriceVaue = try container.decode(Double?.self, forKey: .maxPrice) {
            let currency = try container.decode(Currency.self, forKey: .currency)
            let range = mininumPriceValue...maximumPriceVaue

            self.priceRange = PriceRangeFilter(range: range, currency: currency)
        } else {
            self.priceRange = nil
        }

        if let startDate = try container.decode(Date?.self, forKey: .startDate),
            let endDate = try container.decode(Date?.self, forKey: .endDate) {
            let range = startDate...endDate

            self.dateRange = DateRangeFilter(range: range)
        } else {
            self.dateRange = nil
        }

        if let topLeftLatitude = try container.decode(Double?.self, forKey: .topLeftLatitude),
            let topLeftLongitude = try container.decode(Double?.self, forKey: .topLeftLongitude),
            let bottomRightLatitude = try container.decode(Double?.self, forKey: .bottomRightLatitude),
            let bottomRightLongitude = try container.decode(Double?.self, forKey: .bottomRightLongitude) {

            let topLeftCoordinate = Coordinate(latitude: topLeftLatitude, longitude: topLeftLongitude)
            let bottomRightCoordinate = Coordinate(latitude: bottomRightLatitude, longitude: bottomRightLongitude)

            self.boundingBox = BoundingBox(topLeftCoordinate: topLeftCoordinate, bottomRightCoordinate: bottomRightCoordinate)
            
        } else {
            self.boundingBox = nil
        }

        if let latitude = try container.decode(Double?.self, forKey: .latitude),
            let longitude = try container.decode(Double?.self, forKey: .longitude) {
            self.location = Coordinate(latitude: latitude, longitude: longitude)
        } else {
            self.location = nil
        }
        
        self.categories = try container.decode([BookingItemCategory]?.self, forKey: .categories) ?? []

        self.country = try container.decode(String?.self, forKey: .country)
        self.city = try container.decode(String?.self, forKey: .city)
        
        self.sortOption = try container.decode(ProductItemSortOption?.self, forKey: .sortOption)
        self.sortOrder = try container.decode(ProductItemSortOrder?.self, forKey: .sortOrder)
    }
}
