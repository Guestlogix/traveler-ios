//
//  WishlistRemoveDelegate.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-09-03.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation
/// Notified when removing an item from the wishlist
public protocol WishlistRemoveDelegate: class {
    /**
     Called when the `Product` was removed from the wishlist successfully

     - Parameters:
     - item: The `Product` that was unwishlisted
     - itemDetails: The corresponding `CatalogItemDetails` of the `Product` that was removed from the wishlist. If the removed `Product` is unavailable, it will be nil becuase there's no correspoding `CatalogItemDetails` of a unavailable `Product`.
     */
    func wishlistRemoveDidSucceedFor(_ item: Product, with itemDetails: CatalogItemDetails?)
    /**
     Called when there was an error removing the `Product` from the wishlist

     - Parameters:
     - error: The `Error` representing the reason for failure.
     - result: The original `WishlistResult` passed to `removeFromWishlist` call
     */
    func wishlistRemoveDidFailWith(_ error: Error, result: WishlistResult?)
}
