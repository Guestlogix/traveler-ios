//
//  BookingItemDetails.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-10-04.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// The detailed information of a `BookingItem`
public struct BookingItemDetails: CatalogItemDetails, Decodable {

    /// Identifier
    public let id: String
    /// Price
    public let price: Price
    /// Type
    public let productType: ProductType
    /// Title
    public let title: String
    /// Description
    public let description: String?
    /// An array of URLs of images
    public let imageUrls: [URL]
    /// Attributes
    public let information: [Attribute]?
    /// Vendor's contact information
    public let contact: ContactInfo?
    /// An array of locations
    public let locations: [Location]
    /// Product supplier
    public let supplier: Supplier
    /// Disclaimer
    public let disclaimer: String?
    /// Terms and conditions
    public let termsAndConditions: String?
    /// Indicating if its wishlisted
    public let isWishlisted: Bool?
    /// Google translate attribution 
    public let translateAttribution: ProviderTranslationAttribution
    /// Categories
    public let categories: [ProductItemCategory]

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
        case isWishlisted
        case supplier
        case termsAndConditions
        case disclaimer
        case providerTranslationAttribution
        case categories
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String?.self, forKey: .description)
        self.imageUrls = try container.decode([URL].self, forKey: .imageUrls)
        self.information = try container.decode([Attribute]?.self, forKey: .information)
        self.contact = try container.decode(ContactInfo?.self, forKey: .contact)
        self.locations = try container.decode([Location].self, forKey: .locations)
        self.price = try container.decode(Price.self, forKey: .priceStartingAt)
        self.productType = try container.decode(ProductType.self, forKey: .purchaseStrategy)
        self.isWishlisted = try container.decode(Bool?.self, forKey: .isWishlisted)
        self.supplier = try container.decode(Supplier.self, forKey: .supplier)
        self.termsAndConditions = try container.decode(String?.self, forKey: .termsAndConditions)
        self.disclaimer = try container.decode(String?.self, forKey: .disclaimer)
        self.translateAttribution = try container.decode(ProviderTranslationAttribution.self, forKey: .providerTranslationAttribution)
        self.categories = try container.decode([ProductItemCategory].self, forKey: .categories)
    }
}
