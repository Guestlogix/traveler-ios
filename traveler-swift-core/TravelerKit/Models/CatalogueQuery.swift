//
//  CatalogQuery.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-10-25.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public struct CatalogQuery {
    public var flights: [Flight]?

    public init(flights: [Flight]? = nil) {
        self.flights = flights
    }
}
