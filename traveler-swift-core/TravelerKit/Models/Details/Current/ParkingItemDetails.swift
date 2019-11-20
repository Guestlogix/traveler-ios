//
//  ParkingItemDetails.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-10-04.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// The detailed information of a `ParkingItem`
public struct ParkingItemDetails: CatalogItemDetails, Decodable {
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
    /// Identifier
    public let id: String
    /// Price
    public let price: Price
    /// Type
    public let purchaseType: PurchaseType
    /// Title
    public let title: String
    /// Amount to be paid online
    public let priceToPayOnline: Price
    /// Amount to be paid on site
    public let priceToPayOnsite: Price
    /// Translate attribution
    public let translateAttribution: ProviderTranslationAttribution?
    /// Indicating if it's wishlisted
    public let isWishlisted: Bool?
    /// Secondary title
    public let subTitle: String
    /// URL for a thumbnail
    public let thumbnailURL: URL?
    /// Dates
    public var dateRange: Range<Date>

    enum CodingKeys: String, CodingKey {
        case id
        case payableOnline
        case payableOnSite = "payableOnsite"
        case description
        case imageUrls
        case information
        case contact
        case locations
        case supplier
        case termsAndConditions
        case isWishlisted
        case disclaimer
        case title
        case subTitle
        case thumbnail
        case priceStartingAt
        case purchaseStrategy
        case geoLocation
        case providerTranslationAttribution
        case startTime
        case endTime
        case utcOffsetHours
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.priceToPayOnline = try container.decode(Price.self, forKey: .payableOnline)
        self.priceToPayOnsite = try container.decode(Price.self, forKey: .payableOnSite)
        self.description = try container.decode(String?.self, forKey: .description)
        self.imageUrls = try container.decode([URL].self, forKey: .imageUrls)
        self.information = try container.decode([Attribute]?.self, forKey: .information)
        self.contact = try container.decode(ContactInfo?.self, forKey: .contact)
        self.locations = try container.decode([Location].self, forKey: .locations)
        self.supplier = try container.decode(Supplier.self, forKey: .supplier)
        self.termsAndConditions = try container.decode(String?.self, forKey: .termsAndConditions)
        self.isWishlisted = try container.decode(Bool?.self, forKey: .isWishlisted)
        self.disclaimer = try container.decode(String?.self, forKey: .disclaimer)
        self.title = try container.decode(String.self, forKey: .title)
        self.subTitle = try container.decode(String.self, forKey: .subTitle)
        self.thumbnailURL = try container.decode(URL?.self, forKey: .thumbnail)
        self.price = try container.decode(Price.self, forKey: .priceStartingAt)
        self.purchaseType = try container.decode(PurchaseType.self, forKey: .purchaseStrategy)
        self.translateAttribution = try container.decode(ProviderTranslationAttribution?.self, forKey: .providerTranslationAttribution)

        // TODO: Do the timezone conversion

        let lowerBound = try container.decode(Date.self, forKey: .startTime)
        let upperBound = try container.decode(Date.self, forKey: .endTime)

        self.dateRange = Range(uncheckedBounds: (lower: lowerBound, upper: upperBound))
    }
}
