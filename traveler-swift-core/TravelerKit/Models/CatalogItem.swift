//
//  Purchasable.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-10-25.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

/// An item in the `CatalogGroup`
public struct CatalogItem: Decodable, Product {
    /// Identifier
    public let id: String
    /// Title
    public let title: String
    /// Secondary title
    public let subTitle: String
    /// URL for a thumbnail
    public let imageURL: URL?
    /// Price
    public var price: Price = Price(value: 0.0, currency: "USD") // TODO: API needs to figure out how to display an appropriate starting price at the CatalogItem level

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case subTitle = "subTitle"
        case imageURL = "thumbnail"
        //case price = "priceStartingAt"
    }
}
