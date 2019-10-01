//
//  BookingSearchParameters.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-10-04.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation
/// The search parameters that conform to a `BookingQuery`
struct BookingSearchParameters: Decodable {
    /// Text for text-based queries
    public let text: String?
    ///  Range of prices for items
    public let range: PriceRange?
    /// Item category
    public let categories: [CatalogItemCategory]?
    /// A `BoundingBox`representing the geographic area in which items should be searched for
    public let boundingBox: BoundingBox?

    enum CodingKeys: String, CodingKey {
        case text = "text"
        case topLeftLatitude = "topLeftLatitude"
        case topLeftLongitude = "topLeftLongitude"
        case bottomRightLatitude = "bottomRightLatitude"
        case bottomRightLongitude = "bottomLeftLongitude"
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

            self.range = PriceRange(range: range, currency: currency)
        } else {
            self.range = nil
        }

        if let topLeftLatitude = try container.decode(Double?.self, forKey: .topLeftLatitude),
            let topLeftLongitude = try container.decode(Double?.self, forKey: .topLeftLongitude),
            let bottomRightLatitude = try container.decode(Double?.self, forKey: .bottomRightLatitude),
            let bottomRightLongitude = try container.decode(Double?.self, forKey: .bottomRightLongitude) {
            self.boundingBox = BoundingBox(topLeftLatitude: topLeftLatitude, topLeftLongitude: topLeftLongitude, bottomRightLatitude: bottomRightLatitude, bottomRightLongitude: bottomRightLongitude)
        } else {
            self.boundingBox = nil
        }

        self.categories = try container.decode([CatalogItemCategory]?.self, forKey: .categories)
    }
}
