//
//  WishlistAddDelegate.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-09-03.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// Notified when wishlisting item
public protocol WishlistAddDelegate: class {
    /**
     Called when the `Product` was wishlisted successfully

     - Parameters:
     - item: The `Product` that was wishlisted
     - itemDetails: The corresponding `CatalogItemDetails` of the `Product` that was wishlisted
     */
    func wishlistAddDidSucceedFor(_ item: Product, with itemDetails: CatalogItemDetails)
    /**
     Called when there was an error wishlisting the `Product`

     - Parameters:
     - error: The `Error` representing the reason for failure.
     */
    func wishlistAddDidFailWith(_ error: Error)
}
