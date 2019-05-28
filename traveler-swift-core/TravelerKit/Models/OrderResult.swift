//
//  OrderResult.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-05-06.
//  Copyright © 2019 GuestLogix Inc. All rights reserved.
//

import Foundation

/**
 A result model representing the `Order`s that were fetched for a give `OrderQuery`
 */
public struct OrderResult: Decodable {
    /// The total number of orders matching the given query
    public let total: Int
    /// An `Array<Order>` representing the results of the query
    public let orders: [Int: Order]
    /// The fromDate part of the `OrderQuery` that matches the result
    public let fromDate: Date?
    /// The toDate part of the `OrderQuery` that matches the result
    public let toDate: Date

    enum CodingKeys: String, CodingKey {
        case offset = "skip"
        case limit = "take"
        case fromDate = "from"
        case toDate = "to"
        case total = "total"
        case orders = "result"
    }

    init(total: Int, orders: [Int : Order], fromDate: Date?, toDate: Date) {
        self.total = total
        self.orders = orders
        self.fromDate = fromDate
        self.toDate = toDate
    }

    /**
     Determines if the given OrderResult is result-equivalent to self

     - Parameters:
     - to: The `OrderResult` to compare against

     - Returns: A `Bool` indicating result-equivalency
     */
    public func isResultEquivalent(to: OrderResult) -> Bool {
        return self.fromDate == to.fromDate && self.toDate == to.toDate && self.total == to.total
    }

    /**
     Merges self with the given `OrderResult`.

     - Parameters:
     - result: The `OrderResult` to merge with

     - Returns: A merged `OrderResult` if the two OrderResults are result-equivalent; nil otherwise.
     */
    public func merge(_ result: OrderResult) -> OrderResult? {
        guard self.isResultEquivalent(to: result) else {
            // Not mergable
            return nil
        }

        var orders = self.orders

        for (index, order) in result.orders {
            orders[index] = order
        }

        return OrderResult(total: result.total, orders: orders, fromDate: result.fromDate, toDate: result.toDate)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let offset = try container.decode(Int.self, forKey: .offset)
        let fromDate = try container.decode(Date?.self, forKey: .fromDate)
        let toDate = try container.decode(Date.self, forKey: .toDate)

        self.fromDate = fromDate
        self.toDate = toDate
        self.total = try container.decode(Int.self, forKey: .total)

        let orders = try container.decode([Order].self, forKey: .orders)

        var indexedOrders = [Int : Order]()

        for (idx, order) in orders.enumerated() {
            indexedOrders[idx + offset] = order
        }

        self.orders = indexedOrders
    }
}
