//
//  Pass.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-12-05.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public struct Pass: Decodable, Hashable {
    public static func == (lhs: Pass, rhs: Pass) -> Bool {
        return lhs.id == rhs.id
    }

    public var hashValue: Int {
        return id.hashValue
    }

    let id: String

    public let name: String
    public let description: String?
    public let price: Price

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case price = "price"
    }
}

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

        for (pass, quantity) in self {
            value += (Double(quantity) * pass.price.value)
        }

        return value.priceDescription()
    }
}
