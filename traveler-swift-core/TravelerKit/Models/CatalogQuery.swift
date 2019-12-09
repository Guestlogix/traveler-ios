//
//  CatalogQuery.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-10-25.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

/**
 This type is used to accurately retrieve a `Catalog` that interests the user
 */
public struct CatalogQuery {
    /// Array of `Flight`s to better form a `Catalog`
    public var flights: [Flight]?

    /// Array of `AnyProduct`s to find similar items to
    public var products: [AnyProduct]?

    /**
     Initializes a `CatalogQuery`

     - Parameters:
        - flights: An optional `Array<Flight>`
        - products:  An optional `AnyProduct`

     - Returns: `CatalogQuery`
     */
    public init(flights: [Flight]? = nil, products: [AnyProduct]? = nil) {
        self.flights = flights
        self.products = products
    }
}
