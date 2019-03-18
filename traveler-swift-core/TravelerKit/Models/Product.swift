//
//  Product.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-23.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public protocol Product {
    var id: String { get }
    var price: Double { get }
    var title: String { get }
}

public enum ProductType: String, Decodable {
    case bookable = "bookable"
}

struct AnyProduct: Decodable {
    let id: String
    let price: Double
    let title: String
    let productType: ProductType

    // Properties for BookableProduct
    let passes: [Pass]?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case price = "price"
        case title = "title"
        case productType = "type"
        case passes = "passes"
    }
}

public struct BookableProduct: Product {
    public var price: Double
    public let id: String
    public let title: String
    public let passes: [Pass]
}
