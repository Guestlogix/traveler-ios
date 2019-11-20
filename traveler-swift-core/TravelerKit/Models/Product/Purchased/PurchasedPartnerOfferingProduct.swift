//
//  PurchasedPartnerOfferingProduct.swift
//  TravelerKit
//
//  Created by Rakin Hoque on 2019-12-11.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// Any purchased partner offering
public struct PurchasedPartnerOfferingProduct: PurchasedProduct, Decodable {
    /// Identifier
    public let id: String
    /// Order identifier
    public let orderId: String
    /// Order reference number
    public let orderReferenceNumber: String?
    /// Price
    public let finalPrice: Price
    /// Type
    public let purchaseType: PurchaseType = .partnerOffering
    /// Title
    public let title: String
    /// Date in which the product takes place
    public let eventDate: Date

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case orderId = "orderId"
        case orderReferenceNumber = "orderReferenceNumber"
        case eventDate = "experienceDate"
        case finalPrice = "price"
        case title = "title"
    }
    
    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.orderId = try container.decode(String.self, forKey: .orderId)
        self.orderReferenceNumber = try container.decode(String?.self, forKey: .orderReferenceNumber)
        self.title = try container.decode(String.self, forKey: .title)
        self.finalPrice = try container.decode(Price.self, forKey:.finalPrice)

        let dateString = try container.decode(String.self, forKey: .eventDate)

        if let date = ISO8601DateFormatter.dateOnlyFormatter.date(from: dateString) {
            self.eventDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.eventDate, in: container, debugDescription: "Incorrect format")
        }
    }
}
