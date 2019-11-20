//
//  AnyPurchasedProduct.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-23.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

struct AnyPurchasedProduct: Decodable {
    let payload: PurchasedProduct
    let type: PurchaseType

    enum CodingKeys: String, CodingKey {
        case purchaseType = "purchaseStrategy"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.type = try container.decode(PurchaseType.self, forKey: .purchaseType)

        var product: PurchasedProduct
        switch type {
        case .booking:
            product = try PurchasedBookingProduct(from: decoder)
        case .parking:
            product = try PurchasedParkingProduct(from: decoder)
        case .partnerOffering:
            product = try PurchasedPartnerOfferingProduct(from: decoder)
        }
        
        payload = product
    }
}
