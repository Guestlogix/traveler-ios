//
//  BookingItem.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-10-08.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public struct BookingItem: CatalogItem, Decodable, Product {
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
    // TODO: Call this something different. Location implies that the type is `Location`
    public let location: Coordinate
    /// Whether is item is available or not
    public var isAvailable: Bool
}
