//
//  CatalogItemDetails.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-07.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

/// The detailed information of a `CatalogItem`
public struct CatalogItemDetails: Decodable, Product {
    /// Identifier
    public let id: String
    /// Title
    public let title: String
    /// Description
    public private(set) var description: String?
    /// An array of URLs of images
    public let imageUrls: [URL]
    /// Attributes
    public let information: [Attribute]?
    /// Vendor's contact information
    public let contact: ContactInfo?
    /// An array of locations
    public let locations: [Location]
    /// Starting price
    public let priceStartingAt: Price
    /// Strategy for purchasing the item
    public let purchaseStrategy: PurchaseStrategy
    /// Starting price
    public var price: Price {
        // TODO: Convert currency
        return priceStartingAt
    }

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case imageUrls
        case contact
        case locations
        case priceStartingAt
        case purchaseStrategy
        case information
    }
}

