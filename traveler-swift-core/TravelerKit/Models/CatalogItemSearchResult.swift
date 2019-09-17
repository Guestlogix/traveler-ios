//
//  CatalogItemSearchResult.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-08-19.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/**
 A result model representing the `CatalogItem`s that were fetched for a given `CatalogSearchQuery`
 */
public struct CatalogItemSearchResult: Decodable {
    /// The total number of catalog items matching the given query
    public let total: Int
    /// An `Array<CatalogItem>` representing the results of the query
    public let items: [Int: CatalogItem]
    /// A `Facets` object that informs how the data could be filtered further
    public let facets: Facets
    /// The `CatalogItemSearchQuery` that returns this result
    public let catalogItemSearchQuery: CatalogItemSearchQuery?

    enum CodingKeys: String, CodingKey {
        case offset = "skip"
        case limit = "take"
        case total = "total"
        case items = "items"
        case facets = "aggregation"
        case parameters = "parameters"
    }

    init(total: Int, items: [Int: CatalogItem], facets: Facets, catalogItemSearchQuery: CatalogItemSearchQuery?) {
        self.total = total
        self.items = items
        self.facets = facets
        self.catalogItemSearchQuery = catalogItemSearchQuery
    }

    public func isResultEquivalent(to: CatalogItemSearchResult) -> Bool {
        return self.total == to.total && self.catalogItemSearchQuery == to.catalogItemSearchQuery
    }


    public func merge(_ result: CatalogItemSearchResult) -> CatalogItemSearchResult? {
        guard self.isResultEquivalent(to: result) else {
            // Not mergable
            return nil
        }

        var items = self.items

        for (index, item) in result.items {
            items[index] = item
        }

        return CatalogItemSearchResult(total: result.total, items: items, facets: result.facets, catalogItemSearchQuery: result.catalogItemSearchQuery)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.total = try container.decode(Int.self, forKey: .total)
        self.facets = try container.decode(Facets.self, forKey: .facets)
        let offset = try container.decode(Int.self, forKey: .offset)
        let catalogItems = try container.decode([CatalogItem].self, forKey: .items)

        var indexedItems = [Int : CatalogItem]()

        for (idx, catalogItem) in catalogItems.enumerated() {
            indexedItems[idx + offset] = catalogItem
        }

        self.items = indexedItems

        let searchParameters = try container.decode(CatalogItemSearchParameters.self, forKey: .parameters)

        self.catalogItemSearchQuery = CatalogItemSearchQuery(with: searchParameters)
    }
}
