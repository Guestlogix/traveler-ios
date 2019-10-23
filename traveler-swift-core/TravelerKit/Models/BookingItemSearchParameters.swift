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
    ///  Range of prices for items
    public let range: PriceRangeFilter?
    /// Item category
    public let categories: [ProductItemCategory]

    /// A `BoundingBox`representing the geographic area in which items should be searched for
    public let boundingBox: BoundingBox?

    enum CodingKeys: String, CodingKey {
        case text = "text"
        case topLeftLatitude = "topLeftLatitude"
        case topLeftLongitude = "topLeftLongitude"
        case bottomRightLatitude = "bottomRightLatitude"
        case bottomRightLongitude = "bottomRightLongitude"
        case minPrice = "minPrice"
        case maxPrice = "maxPrice"
        case currency = "currency"
        case categories = "categories"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.text = try container.decode(String?.self, forKey: .text)

        if let mininumPriceValue = try container.decode(Double?.self, forKey: .minPrice),
            let maximumPriceVaue = try container.decode(Double?.self, forKey: .maxPrice) {
            let currency = try container.decode(Currency.self, forKey: .currency)
            let range = mininumPriceValue...maximumPriceVaue

            self.range = PriceRangeFilter(range: range, currency: currency)
        } else {
            self.range = nil
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
        
        self.categories = try container.decode([ProductItemCategory]?.self, forKey: .categories) ?? []

    }
}
