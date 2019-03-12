//
//  Purchasable.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-10-25.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public struct CatalogItem: Decodable, Product {
    public let id: String
    public let title: String
    public let subTitle: String
    public let imageURL: URL?
    public var price: Double {
        return 0 // TODO: Make this mappable
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case subTitle = "subTitle"
        case imageURL = "thumbnail"
        //case price = "priceStartingAt"
    }
}
