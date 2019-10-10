//
//  CategoryFacet.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-08-22.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation
/**
 A model represeting a facet that refers to the categories available in a `CatalogItemSearchResult`.
 */
public struct CategoryFacet: Decodable {
    /// A `Category` that the search result contains
    public let category: ProductItemCategory
    /// A the number of items that belong to that category
    public let quantity: Int

    enum CodingKeys: String, CodingKey {
        case category = "label"
        case count = "count"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.quantity = try container.decode(Int.self, forKey: .count)
        self.category = try container.decode(ProductItemCategory.self, forKey: .category)
    }
}
