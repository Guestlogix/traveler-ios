//
//  BookingItem.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-10-08.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

// TODO: Rename to PurchasableExperienceProduct
public struct BookingItem: CatalogItem, Decodable, Product {
    /// An identifier
    public let id: String
    /// Starting price
    public let price: Price
    /// Type
    public let purchaseType: PurchaseType
    /// Categories
    public let categories: [BookingItemCategory]
    /// A title
    public let title: String
    /// A secondary title
    public let subTitle: String?
    /// A display image
    public let imageURL: URL?
    /// Translation attribution
    public let providerTranslationAttribution: ProviderTranslationAttribution
    /// A coordinate representing the item's location
    // TODO: Call this something different. Location implies that the type is `Location`
    public let location: Coordinate
    /// Whether is item is available or not
    public var isAvailable: Bool

    enum CodingKeys: String, CodingKey {
       case id = "id"
        case title = "title"
        case subTitle = "subTitle"
        case thumbnail = "thumbnail"
        case price = "priceStartingAt"
        case categories = "categories"
        case type = "purchaseStrategy"
        case location = "geoLocation"
        case providerTranslationAttribution = "providerTranslationAttribution"
        case isAvailable = "isAvailable"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.subTitle = try container.decode(String?.self, forKey: .subTitle)
        self.imageURL = try container.decode(URL?.self, forKey: .thumbnail)
        self.price = try container.decode(Price.self, forKey: .price)
        self.categories = try container.decode([BookingItemCategory].self, forKey: .categories)
        self.purchaseType = try container.decode(PurchaseType.self, forKey: .type)
        self.location = try container.decode(Coordinate.self, forKey: .location)
        self.providerTranslationAttribution = try container.decode(ProviderTranslationAttribution.self, forKey: .providerTranslationAttribution)
        self.isAvailable = try container.decode(Bool.self, forKey: .isAvailable)
    }
}
