//
//  AnyPurchasedProductDetails.swift
//  TravelerKit
//
//  Created by Rakin Hoque on 2019-12-09.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

// TODO: Structure of this model is temporary and once backend changes, this should be a type erasure model similar to AnyProduct
public struct AnyPurchasedProductDetails: Decodable {
    /// Purchase type
    public let type: PurchaseType
    /// Purchase details
    public let details: CatalogItemDetails
    /// Purchased product
    public let product: PurchasedProduct
    
    enum CodingKeys: String, CodingKey {
        case type = "purchaseStrategy"
        case details = "itemDetail"
        case product = "orderProduct"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decode(PurchaseType.self, forKey: .type)
        let anyDetails = try container.decode(AnyItemDetails.self, forKey: .details)
        self.details = anyDetails.payload
        let anyProduct = try container.decode(AnyPurchasedProduct.self, forKey: .product)
        self.product = anyProduct.payload
    }
}
