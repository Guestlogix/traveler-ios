//
//  PartnerOfferingsItemDetails.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-11-23.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// The detailed information of a `PartnerOfferingsItem`
public struct PartnerOfferingsItemDetail: CatalogItemDetails, Decodable {
    /// Title
    public let title: String
    /// A description
    public let description: String?
    /// An array of URLs of images
    public let imageUrls: [URL]
    /// Attributes
    public let information: [Attribute]?
    /// Price
    public let price: Price
    /// Vendor's contact information
    public let contact: ContactInfo?
    /// Product supplier
    public let supplier: Supplier
    /// Disclaimer
    public let disclaimer: String?
    /// Terms and conditions
    public let termsAndConditions: String?
    /// Offering options
    public let offerings: [PartnerOfferingGroup]

    enum CodingKeys: String, CodingKey {
        case title = "title"
        case description = "description"
        case imageURLS = "imageUrls"
        case information = "information"
        case contact = "contact"
        case supplier = "supplier"
        case disclaimer = "disclaimer"
        case termsAndConditions = "termsAndConditions"
        case menu = "menu"
        case price = "priceStartingAt"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.imageUrls = try container.decode([URL].self, forKey: .imageURLS)
        self.information = try container.decode([Attribute]?.self, forKey: .information)
        self.contact = try container.decode(ContactInfo.self, forKey: .contact)
        self.supplier = try container.decode(Supplier.self, forKey: .supplier)
        self.disclaimer = try container.decode(String?.self, forKey: .disclaimer)
        self.termsAndConditions = try container.decode(String.self, forKey: .termsAndConditions)
        self.offerings = try container.decode([PartnerOfferingGroup].self, forKey: .menu)
        self.price = try container.decode(Price.self, forKey: .price)
    }
}
