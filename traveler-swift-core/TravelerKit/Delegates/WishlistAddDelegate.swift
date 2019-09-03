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
     Called when the `CatalogItem` was wishlisted successfully
     - Parameters:
     -item: The `CatalogItem`that was wishlisted
     */
    func wishlistAddDidSucceedFor(_ items: [CatalogItem])
    /**
     Called when there was an error wishlisting the `CatalogItem`

     - Parameters:
     - error: The `Error` representing the reason for failure.
     */
    func wishlistAddDidFailWith(_ error: Error)
}
