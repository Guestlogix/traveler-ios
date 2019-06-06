//
//  Product.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-23.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

/// Any product that can be purchased
public protocol Product {
    /// Identifier
    var id: String { get }
    /// Price
    var price: Price { get }
    /// Name
    var title: String { get }
}

/// Different types of product
public enum ProductType: String, Decodable {
    /// Experience or any product that has a booking nature
    case bookable = "Bookable"
}

struct AnyProduct: Decodable {
    let id: String
    let price: Price
    let title: String
    let productType: ProductType

    // Properties for BookableProduct
    let passes: [Pass]?
    let eventDate: Date

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case price = "price"
        case title = "title"
        case productType = "purchaseStrategy"
        case eventDate = "experienceDate"
        case passes = "passes"
    }

    public init (from decoder:Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.productType = try container.decode(ProductType.self, forKey: .productType)
        self.passes = try container.decode([Pass]?.self, forKey: .passes) ?? nil
        self.price = try container.decode(Price.self, forKey:.price)


        let dateString = try container.decode(String.self, forKey: .eventDate)

        if let date = ISO8601DateFormatter.dateOnlyFormatter.date(from: dateString) {
            self.eventDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.eventDate, in: container, debugDescription: "Incorrect format")
        }
    }
}

/// Any purchased bookable product
public struct BookableProduct: Product {
    /// Identifier
    public let id: String
    /// Name
    public let title: String
    /// Array of different `Pass`es purchased
    public let passes: [Pass]
    /// Date in which the product takes place
    public let eventDate: Date
    /// Price of product
    public let price: Price
}
