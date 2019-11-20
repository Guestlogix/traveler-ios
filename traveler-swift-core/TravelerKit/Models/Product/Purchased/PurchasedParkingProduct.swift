//
//  PurchasedParkingProduct.swift
//  TravelerKit
//
//  Created by Rakin Hoque on 2019-11-28.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// Any purchased parking product:
public struct PurchasedParkingProduct: PurchasedProduct, Decodable {
    // TODO: Remove this model once aggregated model is available
    private struct PostPurchaseDetail: Decodable {
        /// Primary contact information
        let primaryContact: String?
        /// Order detail information
        let orderDetail: String?
        
        enum CodingKeys: String, CodingKey {
            case primaryContact = "primaryContactInfo"
            case orderDetail = "orderDetailInfo"
        }

        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.primaryContact = try container.decode(String?.self, forKey: .primaryContact)
            self.orderDetail = try container.decode(String?.self, forKey: .orderDetail)
        }
    }
    
    /// Identifier
    public let id: String
    /// Order identifier
    public let orderId: String
    /// Order reference number
    public let orderReferenceNumber: String?
    /// Price of product
    public let finalPrice: Price
    /// Type
    public let purchaseType: PurchaseType = .parking
    /// A title
    public let title: String
    /// Date in which the product takes place
    public let eventDate: Date
    /// Attributes
    public let information: [Attribute]
    /// Array of different `Pass`es purchased
    public let passes: [Pass]
    /// Primary contact information
    public let primaryContact: String?
    /// Order detail information
    public let orderDetail: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case orderId = "orderId"
        case orderReferenceNumber = "orderReferenceNumber"
        case title = "title"
        case purchaseType = "purchaseStrategy"
        case eventDate = "experienceDate"
        case finalPrice = "price"
        case information = "information"
        case passes = "passes"
        case details = "postPurchaseDetail"
    }

    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.orderId = try container.decode(String.self, forKey: .orderId)
        self.orderReferenceNumber = try container.decode(String?.self, forKey: .orderReferenceNumber)
        self.title = try container.decode(String.self, forKey: .title)
        self.finalPrice = try container.decode(Price.self, forKey:.finalPrice)
        self.information = try container.decode([Attribute]?.self, forKey: .information) ?? []
        self.passes = try container.decode([Pass]?.self, forKey: .passes) ?? []
        
        let details = try container.decodeIfPresent(PostPurchaseDetail?.self, forKey: .details) as? PostPurchaseDetail
        self.primaryContact = details?.primaryContact
        self.orderDetail = details?.orderDetail

        let dateString = try container.decode(String.self, forKey: .eventDate)

        if let date = ISO8601DateFormatter.dateOnlyFormatter.date(from: dateString) {
            self.eventDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.eventDate, in: container, debugDescription: "Incorrect format")
        }
    }
}
