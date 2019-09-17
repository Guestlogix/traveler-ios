//
//  ProductItem.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-10-04.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// An item in the `CatalogGroup` that represents a product
public struct ProductItem: CatalogItem, Product, Decodable {
    /// Title
    public let title: String
    /// Secondary title
    public let subTitle: String?
    /// URL for a thumbnail
    public let imageURL: URL?
    /// Identifier
    public let id: String
    /// Starting price
    public let price: Price
    /// The `ProductType`
    public let type: ProductType
    /// The categories which the product belongs to
    public let categories: [ProductItemCategory]

    enum CodingKeys: String, CodingKey {
        case title = "title"
        case subTitle = "subTitle"
        case imageURL = "thumbnail"
        case price = "priceStartingAt"
        case categories = "categories"
        case id = "id"
        case type = "purchaseStrategy"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.subTitle = try container.decode(String?.self, forKey: .subTitle)
        self.imageURL = try container.decode(URL?.self, forKey: .imageURL)
        self.id = try container.decode(String.self, forKey: .id)
        self.price = try container.decode(Price.self, forKey: .price)
        self.type = try container.decode(ProductType.self, forKey: .type)
        self.categories = try container.decode([ProductItemCategory].self, forKey: .categories)
    }

}
