//
//  PurchasableGroup.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-10-25.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public struct CatalogGroup: Decodable {
    public let isFeatured: Bool
    public let title: String
    public let subTitle: String?
    public private(set) var items: [CatalogItem]

    enum CodingKeys: String, CodingKey {
        case isFeatured = "featured"
        case title = "title"
        case subTitle = "subTitle"
        case items = "items"
    }
}
