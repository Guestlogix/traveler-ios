//
//  PriceLimits.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-08-20.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation
/**
 A model represeting a facet that relates to the maximum and minimum prices that items in a `CatalogItemSearchResult` may have.
 */
struct PriceLimits: Decodable {
    /// The maximum price available for all the items in a `CatalogItemSearchResult`
    public let max: Price
    /// The minimum price available for all the items in a `CatalogItemSearchResult`
    public let min: Price

    enum CodingKeys: String, CodingKey {
        case max = "max"
        case min = "min"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.max = try container.decode(Price.self, forKey: .max)
        self.min = try container.decode(Price.self, forKey: .min)
    }
}
