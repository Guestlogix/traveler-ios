//
//  ProductItemSort.swift
//  TravelerKit
//
//  Created by Rakin Hoque on 2019-11-18.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// Represents the combination of sorting options and ordering a `Product` based query can have
public enum ProductItemSort: Int, CaseIterable {
    case priceAscending
    case priceDescending
    case titleAscending
    case titleDescending
    
    public var option: ProductItemSortOption {
        switch self {
        case .priceAscending, .priceDescending:
            return .price
        case .titleAscending, .titleDescending:
            return .title
        }
    }
    
    public var order: ProductItemSortOrder {
        switch self {
        case .priceAscending, .titleAscending:
            return .ascending
        case .priceDescending, .titleDescending:
            return .descending
        }
    }
}

/// Represents the different sorting options a `Product` based query can have
public enum ProductItemSortOption: String, Decodable {
    case price = "Price"
    case title = "Title"
}

/// Represents the different sorting orders a `Product` based query can have
public enum ProductItemSortOrder: String, Decodable {
    case ascending = "Asc"
    case descending = "Desc"
}
