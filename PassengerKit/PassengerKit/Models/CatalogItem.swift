//
//  Purchasable.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-10-25.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public struct CatalogItem: Decodable {
    public let title: String
    public let subTitle: String
    public let imageURL: URL?

    enum CodingKeys: String, CodingKey {
        case title = "title"
        case subTitle = "subTitle"
        case imageURL = "thumbnail"
    }
}
