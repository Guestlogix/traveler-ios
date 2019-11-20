//
//  PurchasedBookingProduct.swift
//  TravelerKit
//
//  Created by Rakin Hoque on 2019-11-28.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// Any purchased booking product
public struct PurchasedBookingProduct: PurchasedProduct, Decodable {
    /// Identifier
    public let id: String
    /// Order identifier
    public let orderId: String
    /// Order reference number
    public let orderReferenceNumber: String?
    /// Name
    public let title: String
    /// Array of different `Pass`es purchased
    public let passes: [Pass]
    /// Date in which the product takes place
    public let eventDate: Date
    /// Price of product
    public let finalPrice: Price
    /// Type
    public let purchaseType: PurchaseType = .booking
    /// Categories
    public let categories: [BookingItemCategory]
    /// Attributes
    public let information: [Attribute]?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case orderId = "orderId"
        case orderReferenceNumber = "orderReferenceNumber"
        case title = "title"
        case passes = "passes"
        case categories = "categories"
        case purchaseType = "purchaseStrategy"
        case eventDate = "experienceDate"
        case finalPrice = "price"
        case information = "information"
    }

    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.orderId = try container.decode(String.self, forKey: .orderId)
        self.orderReferenceNumber = try container.decode(String?.self, forKey: .orderReferenceNumber)
        self.title = try container.decode(String.self, forKey: .title)
        self.passes = try container.decode([Pass]?.self, forKey: .passes) ?? []
        self.finalPrice = try container.decode(Price.self, forKey:.finalPrice)
        self.categories = try container.decode([BookingItemCategory].self, forKey: .categories)
        self.information = try container.decode([Attribute]?.self, forKey: .information)

        let dateString = try container.decode(String.self, forKey: .eventDate)

        if let date = ISO8601DateFormatter.dateOnlyFormatter.date(from: dateString) {
            self.eventDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.eventDate, in: container, debugDescription: "Incorrect format")
        }
    }
}
