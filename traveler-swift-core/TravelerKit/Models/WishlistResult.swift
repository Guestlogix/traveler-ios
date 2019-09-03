//
//  WishlistResult.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-09-03.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation
/**
 A result model representing the `CatalogItems`s that were fetched for a given `WishlistQuery`
 */
public struct WishlistResult: Decodable {
    /// The total number of orders matching the given query
    public private(set) var total: Int
    /// An `Array<CatalogItem>` representing the results of the query
    public private(set) var items: [Int: CatalogItem]
    /// The fromDate part of the `WishlistQuery`that matches the result
    public let fromDate: Date?
    /// The toDate part of the `WishlistQuery` that matches the result
    public let toDate: Date

    enum CodingKeys: String, CodingKey {
        case offset = "skip"
        case limit = "take"
        case fromDate = "from"
        case toDate = "to"
        case total = "total"
        case items = "result"
    }

    init(total: Int, items: [Int: CatalogItem], fromDate: Date?, toDate: Date) {
        self.total = total
        self.items = items
        self.fromDate = fromDate
        self.toDate = toDate
    }

    /**
     Determines if the given WishlistResult is result-equivalent to self

     - Parameters:
     - to: The `WishlistResult` to compare against

     - Returns: A `Bool` indicating result-equivalency
     */

    public func isResultEquivalent(to: WishlistResult) -> Bool {
        return self.fromDate == to.fromDate && self.toDate == to.toDate && self.total == to.total
    }

    /**
     Merges self with the given `WishlistResult`.

     - Parameters:
     - result: The `WishlistResult` to merge with

     - Returns: A merged `WishlistResult` if the two WishlistResults are result-equivalent; nil otherwise.
     */

    public func merge(_ result: WishlistResult) -> WishlistResult? {
        guard self.isResultEquivalent(to: result) else {
            // Not mergable
            return nil
        }

        var items = self.items

        for (index, item) in result.items {
            items[index] = item
        }

        return WishlistResult(total: result.total, items: items, fromDate: result.fromDate, toDate: result.toDate)
    }

    @discardableResult
    public mutating func remove(_ item: Product) -> Bool {
        guard let existingItemPair = items.first(where: { $0.value.id == item.id }) else {
            return false
        }

        let itemIndex = existingItemPair.key

        items.removeValue(forKey: itemIndex)

        var updatedItems = [Int: CatalogItem]()
        for (key, value) in items {
            updatedItems[key > itemIndex ? (key - 1) : key] = value
        }

        items = updatedItems
        total -= 1

        return true
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let offset = try container.decode(Int.self, forKey: .offset)
        let fromDate = try container.decode(Date?.self, forKey: .fromDate)
        let toDate = try container.decode(Date.self, forKey: .toDate)

        self.fromDate = fromDate
        self.toDate = toDate
        self.total = try container.decode(Int.self, forKey: .total)

        let items = try container.decode([CatalogItem].self, forKey: .items)

        var indexedItems = [Int : CatalogItem]()
        for (index, item) in items.enumerated() {
            indexedItems[index + offset] = item
        }

        self.items = indexedItems
    }
}
