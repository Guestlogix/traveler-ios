//
//  WishlistQuery.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-09-03.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation
/**
 This type is used to accurately retrieve a wishlist of catalog items that interest the user.
 */
public struct WishlistQuery {
    /// Pagination offset
    public let offset: Int
    /// Pagination limit
    public let limit: Int
    /// Start date (Catalog Items that were wishlisted after this date)
    public let fromDate: Date?
    /// End date (Catalog Items that were wishlisted before this date)
    public let toDate: Date

    /**
     Initializes an `WishlistQuery`

     - Parameters:
     - offset: Pagination offset, default to 0
     - limit : Pagination limit, defualt to 10
     - from : CatalogItems that were wishlisted after this date, default to nil
     - to : CatalogItems that were wishlisted before this date, passing nil will default to NOW
     */
    public init(offset: Int = 0 , limit: Int = 10, from: Date? = nil, to: Date? = nil) {
        self.offset = offset
        self.limit = limit
        self.fromDate = from
        self.toDate = to ?? Date()
    }

}
