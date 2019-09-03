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
     Called when the `CatalogItem` was removed from the wishlist successfully
     - Parameters:
     -item: The `CatalogItem`that was removed from the wishlist
     */
    func wishlistRemoveDidSucceed()
    /**
     Called when there was an error removing the `CatalogItem` from the wishlist

     - Parameters:
     - error: The `Error` representing the reason for failure.
     */
    func wishlistRemoveDidFailWith(_ error: Error, result: WishlistResult?)
}
