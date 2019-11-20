//
//  PurchasedProductDetailsQuery.swift
//  TravelerKit
//
//  Created by Rakin Hoque on 2019-12-10.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

// TODO: Remove this once `PurchasedProduct` is returned as part of `ItineraryItem`s
/**
 This type is used to accurately retrieve a wishlist of catalog items that interest the user.
 */
public struct PurchasedProductDetailsQuery {
    /// Order identifier
    public let orderId: String
    /// Product identifier
    public let productId: String
    /// Purchase type
    public let purchaseType: PurchaseType

    /**
     Initializes an `PurchasedProductDetailsQuery`

     - Parameters:
     - orderId: Order identifier
     - productId : Product identifier
     - purchaseType: Purchase type
     */
    public init(orderId: String, productId: String, purchaseType: PurchaseType) {
        self.orderId = orderId
        self.productId = productId
        self.purchaseType = purchaseType
    }
}
