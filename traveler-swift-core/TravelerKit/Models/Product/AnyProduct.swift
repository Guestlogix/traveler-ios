//
//  Item.swift
//  TravelerKit
//
//  Created by Rakin Hoque on 2019-11-28.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public protocol AnyProduct {
    /// Identifier
    var id: String { get }
    /// Type
    var purchaseType: PurchaseType { get }
    /// Title
    var title: String { get }
}

/// Any product that has been purchased
public protocol PurchasedProduct: AnyProduct {
    /// Amount paid for product
    var finalPrice: Price { get }
    /// Date in which the product takes place
    var eventDate: Date { get }
    /// Order identifier
    var orderId: String { get }
    /// Order reference number
    var orderReferenceNumber: String? { get }
}

// TODO: Rename to PurchasableProduct
/// Any product that is purchasable
public protocol Product: AnyProduct {
    /// Amount product may be purchased for
    var price: Price { get }
}
