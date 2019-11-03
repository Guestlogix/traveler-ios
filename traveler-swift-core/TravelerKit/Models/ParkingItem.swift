//
//  ParkingItem.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-10-08.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public struct ParkingItem: CatalogItem, Decodable, Product {
    /// An identifier
    public let id: String
    /// Starting price
    public let price: Price
    /// Product type
    public let productType: ProductType
    /// Categories
    public let categories: [ProductItemCategory]
    /// A title
    public let title: String
    /// A secondary title
    public let subTitle: String?
    /// A display image
    public let imageURL: URL?
    /// Translation attribution
    public let providerTranslationAttribution: ProviderTranslationAttribution
    /// A coordinate representing the item's location
    public let location: Coordinate
    /// A ParkingItem that is seen is always available
    // TODO: Do a calculation on the time, I think the backend should decide how long these items are available
    public var isAvailable: Bool { return true }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case subTitle = "subTitle"
        case imageURL = "thumbnail"
        case price = "priceStartingAt"
        case categories = "categories"
        case productType = "purchaseStrategy"
        case location = "geoLocation"
        case providerTranslationAttribution = "providerTranslationAttribution"
    }
}
