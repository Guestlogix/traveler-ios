//
//  CatalogItemSearchFilters.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-09-15.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public struct CatalogItemSearchFilters {
    public var categories: [CatalogItemCategory]?
    public var priceRange: PriceRange?

    public init() {}
}
