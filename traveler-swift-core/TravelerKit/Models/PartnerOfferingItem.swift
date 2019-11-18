//
//  PartnerOfferingItem.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-11-22.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public struct PartnerOfferingItem: CatalogItem, Product, Decodable {
    /// A title
    public let title: String
    /// A secondary title
    public let subTitle: String?
    /// A display image
    public let imageURL: URL?
    /// Whether item is available or not
    public let isAvailable: Bool
    /// An identifier
    public let id: String
    /// Starting price
    public let price: Price
    /// Product type
    public let productType: ProductType = .partnerOffering

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case subtitle = "subTitle"
        case thumbnail = "thumbnail"
        case price = "priceStartingAt"
        case isAvailable = "isAvailable"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.subTitle = try container.decode(String?.self, forKey: .subtitle)
        self.imageURL = try container.decode(URL?.self, forKey: .thumbnail)
        self.price = try container.decode(Price.self, forKey: .price)
        self.isAvailable = try container.decode(Bool.self, forKey: .isAvailable)
    }
}
