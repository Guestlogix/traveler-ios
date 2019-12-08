//
//  Product.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-23.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

/// Any product that can be purchased
/// Note: `Product` is directly related to `Order` but also being conformed by `BookingItem`, `ParkingItem` and `items` in `WishlistResult`. Another refactoring might be needed later.
public protocol Product {
    /// Identifier
    var id: String { get }
    /// Price
    var price: Price { get }
    /// Type
    var productType: ProductType { get }
    /// Title
    var title: String { get }
}

struct AnyProduct: Decodable {

    let bookingProduct: BookingProduct?
    let parkingProduct: ParkingProduct?
    let partnerOfferingProduct: PartnerOfferingProduct?

    let type: ProductType

    enum CodingKeys: String, CodingKey {
        case productType = "purchaseStrategy"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.type = try container.decode(ProductType.self, forKey: .productType)

        switch type {
        case .booking:
            self.bookingProduct = try BookingProduct(from: decoder)
            self.parkingProduct = nil
            self.partnerOfferingProduct = nil
        case .parking:
            self.parkingProduct = try ParkingProduct(from: decoder)
            self.bookingProduct = nil
            self.partnerOfferingProduct = nil
        case .partnerOffering:
            self.parkingProduct = nil
            self.bookingProduct = nil
            self.partnerOfferingProduct = try PartnerOfferingProduct(from: decoder)
        }
    }
}

//TODO: Revisit these models when new endpoint for purchased items is available. Consider potential refactoring for SDK with products that have already been purchased.

/// Any purchased partner offering
public struct PartnerOfferingProduct: Product, Decodable {
    /// Identifier
    public let id: String
    /// Price
    public let price: Price
    /// Product type
    public let productType: ProductType = .partnerOffering
    /// Title
    public let title: String
    /// Array of different groups with purchased options
    public let offerings: [PartnerOfferingGroup]

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case price = "price"
        case title = "title"
        case offerings = "menu"
    }

}

///Any purchased parking product:
public struct ParkingProduct: Product, Decodable {
    /// Identifier
    public let id: String
    /// Price of product
    public let price: Price
    /// Product type
    public let productType: ProductType = .parking
    /// A title
    public let title: String
    /// Date in which the product takes place
    public let eventDate: Date

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case productType = "purchaseStrategy"
        case eventDate = "experienceDate"
        case price = "price"
    }

    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.price = try container.decode(Price.self, forKey:.price)

        let dateString = try container.decode(String.self, forKey: .eventDate)

        if let date = ISO8601DateFormatter.dateOnlyFormatter.date(from: dateString) {
            self.eventDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.eventDate, in: container, debugDescription: "Incorrect format")
        }
    }

}

/// Any purchased booking product
public struct BookingProduct: Product, Decodable {
    /// Identifier
    public let id: String
    /// Name
    public let title: String
    /// Array of different `Pass`es purchased
    public let passes: [Pass]
    /// Date in which the product takes place
    public let eventDate: Date
    /// Price of product
    public let price: Price
    /// Product type
    public let productType: ProductType = .booking
    /// Categories
    public let categories: [ProductItemCategory]

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case passes = "passes"
        case categories = "categories"
        case productType = "purchaseStrategy"
        case eventDate = "experienceDate"
        case price = "price"
    }

    public init (from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .title)
        self.passes = try container.decode([Pass]?.self, forKey: .passes) ?? []
        self.price = try container.decode(Price.self, forKey:.price)
        self.categories = try container.decode([ProductItemCategory].self, forKey: .categories)

        let dateString = try container.decode(String.self, forKey: .eventDate)

        if let date = ISO8601DateFormatter.dateOnlyFormatter.date(from: dateString) {
            self.eventDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.eventDate, in: container, debugDescription: "Incorrect format")
        }
    }
}
