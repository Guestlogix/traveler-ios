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
    /// The `CatalogItem`s in this group
    public private(set) var items: [CatalogItem]

    enum CodingKeys: String, CodingKey {
        case isFeatured = "featured"
        case title = "title"
        case subTitle = "subTitle"
        case items = "items"
    }
}
