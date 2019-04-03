//
//  Product.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-23.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

/// Any product that can be purchased
public protocol Product {
    /// Identifier
    var id: String { get }
<<<<<<< HEAD
    /// Price
    //var price: Double { get }
    /// Name
=======
    var price: Price { get }
>>>>>>> Uses price model and modifies to use currency symbol from price model
    var title: String { get }
}

/// Different types of product
public enum ProductType: String, Decodable {
    /// Experience or any product that has a booking nature
    case bookable = "Bookable"
}

struct AnyProduct: Decodable {
    let id: String
    let price: Price
    let title: String
    let productType: ProductType

    // Properties for BookableProduct
    let passes: [Pass]?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case price = "price"
        case title = "title"
        case productType = "purchaseStrategy"
        case passes = "passes"
    }
}

/// Any purchased bookable product
public struct BookableProduct: Product {
    /// Identifier
    public let id: String
    /// Name
    public let title: String
    /// Array of different `Pass`es purchased
    public let passes: [Pass]
    public let price: Price
}
