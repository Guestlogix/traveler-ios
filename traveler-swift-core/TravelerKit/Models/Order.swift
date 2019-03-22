//
//  Order.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-01-25.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public enum OrderStatus: String, Decodable {
    case pending = "pending"
    case processed = "processed"
}

public struct Order: Decodable {
    public let id: String
    public let total: Price
    public let orderNumber: String
    public let products: [Product]
    public let status: OrderStatus
    public let createdDate: Date
    //public let orderDetails: OrderDetails

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case total = "amount"
        case orderNumber = "orderNumber"
        case products = "products"
        case status = "status"
        case createdDate = "createdAt"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.total = try container.decode(Price.self, forKey: .total)
        self.orderNumber = try container.decode(String.self, forKey: .orderNumber)
        self.status = try container.decode(OrderStatus.self, forKey: .status)

        let dateString = try container.decode(String.self, forKey: .createdDate)

        let dateComponents = dateString.components(separatedBy: "T")
        let splitDate = dateComponents[0]

        if let date = DateFormatter.dateOnlyFormatter.date(from: splitDate) {
            self.createdDate = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.createdDate, in: container, debugDescription: "Incorrect format")
        }

        self.products = try container.decode([AnyProduct].self, forKey: .products).map { product in
            switch product.productType {
            case .bookable:
                return BookableProduct(id: product.id, title: product.title, passes: product.passes!)
            }
        }
    }
}
