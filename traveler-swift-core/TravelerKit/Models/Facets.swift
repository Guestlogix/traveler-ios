//
//  Facets.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-08-19.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation
/**
 A model representing different ways in which the items in `CatalogSearchResult` can be aggregated
 */
public struct Facets: Decodable {
    /// Minium price available for items delivered in the catalog search result
    public let minPrice: Price
    /// Maximum price available for items delivered in the catalog search result
    public let maxPrice: Price
    /// Categories available for items delivered in the catalog search result
    public let categories: [CategoryFacet]

    enum CodingKeys: String, CodingKey{
        case prices = "price"
        case categories = "categories"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let priceLimit = try container.decode(PriceLimits.self, forKey: .prices)
        self.minPrice = priceLimit.min
        self.maxPrice = priceLimit.max

        self.categories = try container.decode([CategoryFacet].self, forKey: .categories)
    }

}
