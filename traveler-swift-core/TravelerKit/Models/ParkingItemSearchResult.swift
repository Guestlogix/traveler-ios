//
//  ParkingItemSearchResult.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-10-06.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/**
 A result model representing the `ParkingItem`s that were fetched for a given `ParkingItemSearchQuery`
 */
public struct ParkingItemSearchResult: Decodable {
    /// The total number of catalog items matching the given query
    public let total: Int
    /// An `Array<ParkingItem>` representing the results of the query
    public let items: [Int: ParkingItem]
    /// A `Facets` object that informs how the data could be filtered further
    public let facets: Facets
    /// The `BookingItemQuery` that returns this result
    public let query: ParkingItemQuery

    enum CodingKeys: String, CodingKey {
        case offset = "skip"
        case limit = "take"
        case total = "total"
        case items = "items"
        case facets = "aggregation"
        case parameters = "parameters"
    }

    init(total: Int, items: [Int: ParkingItem], facets: Facets, query: ParkingItemQuery) {
        self.total = total
        self.items = items
        self.facets = facets
        self.query = query
    }

    public func isResultEquivalent(to: ParkingItemSearchResult) -> Bool {
        return self.total == to.total && self.query == to.query
    }


    public func merge(_ result: ParkingItemSearchResult) -> ParkingItemSearchResult? {
        guard self.isResultEquivalent(to: result) else {
            // Not mergable
            return nil
        }

        var items = self.items

        for (index, item) in result.items {
            items[index] = item
        }

        return ParkingItemSearchResult(total: result.total, items: items, facets: result.facets, query: result.query)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.total = try container.decode(Int.self, forKey: .total)
        self.facets = try container.decode(Facets.self, forKey: .facets)
        let offset = try container.decode(Int.self, forKey: .offset)
        let catalogItems = try container.decode([ParkingItem].self, forKey: .items)

        var indexedItems = [Int : ParkingItem]()

        for (idx, productItem) in catalogItems.enumerated() {
            indexedItems[idx + offset] = productItem
        }

        self.items = indexedItems

        let searchParameters = try container.decode(ParkingItemSearchParameters.self, forKey: .parameters)

        self.query = ParkingItemQuery(with: searchParameters)
    }
}
