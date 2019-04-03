//
//  Pass.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-12-05.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

/**
 This type represents the type of admission for a bookable product. As an example
 a tour may have different passes for adults, children and infants.
 */
public struct Pass: Decodable, Hashable {
    public static func == (lhs: Pass, rhs: Pass) -> Bool {
        return lhs.id == rhs.id
    }

    public var hashValue: Int {
        return id.hashValue
    }

    let id: String

    /// Title
    public let name: String
    /// Description
    public let description: String?
    /// Price
    public let price: Price

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "title"
        case description = "description"
        case price = "price"
    }
}
<<<<<<< HEAD
=======

extension Array where Element == Pass {
    public var defaultPassQuantities: [Pass: Int] {
        guard count > 0 else {
            return [:]
        }

        return [first! : 1]
    }
}

extension Dictionary where Key == Pass, Value == Int {
    public var subTotalDescription: String? {
        var value: Double = 0
        var currency: String = "USD"

        for (pass, quantity) in self {
            value += (Double(quantity) * pass.price.value)
            currency = pass.price.currency
        }

        return Price(value: value, currency: currency).localizedDescription
    }
}
>>>>>>> Uses price model and modifies to use currency symbol from price model
