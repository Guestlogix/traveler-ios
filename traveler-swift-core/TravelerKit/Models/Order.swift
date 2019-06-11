//
//  Order.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-01-25.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// Represents the different statuses an `Order` can have
public enum OrderStatus: String, Decodable {
    /// The `Order` is being processed
    case pending = "Pending"
    /// The `Order` has been successfully processed
    case confirmed = "Confirmed"
    /// Payment failed
    case declined = "Declined"
    /// Traveler asked for a cancellation and the `Order` is under review
    case underReview = "UnderReview"
    /// `Order` is cancelled
    case cancelled = "Cancelled"
}

/// Holds information about an order
public struct Order: Decodable, Equatable, Hashable {
    public static func == (lhs: Order, rhs: Order) -> Bool {
        return lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    /// The identification `String`
    public let id: String
    /// Total amount
    public let total: Price
    /// Order number for confirmation purposes
    public let referenceNumber: String?
    /// The `Product`s that were included in the order
    public let products: [Product]
    /// The current status
    public let status: OrderStatus
    /// The date and time the order was created
    public let createdDate: Date
    /// The email of the primary contact
    public let email: CustomerContact
    /// The last four digits of credit card
    public let last4Digits: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case total = "amount"
        case referenceNumber = "referenceNumber"
        case products = "products"
        case status = "status"
        case createdDate = "createdOn"
        case email = "customer"
        case last4Digits = "last4Digits"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.total = try container.decode(Price.self, forKey: .total)
        self.referenceNumber = try container.decode(String?.self, forKey: .referenceNumber) ?? nil
        self.status = try container.decode(OrderStatus.self, forKey: .status)

        let dateString = try container.decode(String.self, forKey: .createdDate)

        if let date = ISO8601DateFormatter.dateOnlyFormatter.date(from: dateString) {
            self.createdDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.createdDate, in: container, debugDescription: "Incorrect format")
        }

        self.products = try container.decode([AnyProduct].self, forKey: .products).map { product in
            switch product.productType {
            case .bookable:
                return BookableProduct(id: product.id, title: product.title, passes: product.passes!, eventDate: product.eventDate, price: product.price)
            }
        }

        self.email = try container.decode(CustomerContact.self, forKey: .email)
        self.last4Digits = try container.decode(String?.self, forKey: .last4Digits) ?? nil
    }
}
