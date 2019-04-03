//
//  CatalogQuery.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-10-25.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

/**
 This type is used to accurately retreive a `Catalog` that interests the user
 */
public struct CatalogQuery {
    /// Array of `Flight`s to better form a `Catalog`
    public var flights: [Flight]?

    /**
     Intializes a `CatalogQuery`

     - Parameters:
     - flights: An optional `Array<Flight>`

     - Returns: `CatalogQuery`
     */
    public init(flights: [Flight]? = nil) {
        self.flights = flights
    }
}
