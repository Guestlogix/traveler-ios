//
//  CancellationQuote.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-05-24.
//  Copyright © 2019 GuestLogix Inc. All rights reserved.
//

import Foundation

/// This represents the amount that will be refunded should the corresponding `Order` be cancelled
public struct CancellationQuote {
    let id: String

    /// Total amount that will be refunded
    public let totalRefund: Price
    /// Charge for cancellation
    public let cancellationCharge: Price
    /// The cancellation quote is only valid until this date
    public let expirationDate: Date
    /// Per product cancellation quotes
    public let products: [ProductCancellationQuote]
    /// The `Order` that was cancelled
    public let order: Order

    init(cancellationQuoteResponse: CancellationQuoteResponse, order: Order) {
        self.id = cancellationQuoteResponse.id
        self.totalRefund = cancellationQuoteResponse.totalRefund
        self.cancellationCharge = cancellationQuoteResponse.cancellationCharge
        self.expirationDate = cancellationQuoteResponse.expirationDate
        self.products = cancellationQuoteResponse.products
        self.order = order
    }
}

struct CancellationQuoteResponse: Decodable {
    let id: String
    let totalRefund: Price
    let cancellationCharge: Price
    let expirationDate: Date
    let products: [ProductCancellationQuote]

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case totalRefund = "totalRefund"
        case cancellationCharge = "cancellationCharge"
        case expirationDate = "quoteExpiresOn"
        case products = "products"
    }

    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.totalRefund = try container.decode(Price.self, forKey: .totalRefund)
        self.cancellationCharge = try container.decode(Price.self, forKey: .cancellationCharge)

        let dateString = try container.decode(String.self, forKey: .expirationDate)

        if let date = DateFormatter.withoutTimezone.date(from: dateString) {
            self.expirationDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.expirationDate, in: container, debugDescription: "Incorrect format")
        }

        self.products = try container.decode([ProductCancellationQuote].self, forKey: .products)
    }
}

/// Per product cancellation quote
public struct ProductCancellationQuote: Decodable {
    public let title: String
    public let totalRefund: Price
    public let cancellationCharge: Price
}
