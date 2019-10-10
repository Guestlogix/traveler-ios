//
//  PurchasableGroup.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-10-25.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

/// Group of `CatalogItem`s
public struct CatalogGroup: Decodable {
    /// Determines if this is a featured group, featured groups are recommended to be highlighted to the user
    public let isFeatured: Bool
    /// Title
    public let title: String
    /// Secondary title
    public let subTitle: String?
    /// The type of item in the current group
    public let itemType: CatalogItemType
    /// The `CatalogItem`s in this group
    public private(set) var items: [CatalogItem]

    enum CodingKeys: String, CodingKey {
        case isFeatured = "featured"
        case title = "title"
        case subTitle = "subTitle"
        case items = "items"
        case type = "type"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.isFeatured = try container.decode(Bool.self, forKey: .isFeatured)
        self.title = try container.decode(String.self, forKey: .title)
        self.subTitle = try container.decode(String?.self, forKey: .subTitle)
        
        self.itemType = try container.decode(CatalogItemType.self, forKey: .type)

        switch itemType {
        case .item:
            let anyItem = try container.decode([AnyItem].self, forKey: .items)
            self.items = anyItem.map({ (item) -> CatalogItem in
                switch item.type {
                case .booking:
                    return item.bookingItem!
                case .parking:
                    return item.parkingItem!
                }

            })
        case .query:
            self.items = try container.decode([QueryItem].self, forKey: .items)
        }
    }
}
