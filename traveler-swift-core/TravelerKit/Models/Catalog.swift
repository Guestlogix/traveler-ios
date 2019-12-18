//
//  Catalog.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-10-25.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

/// Represent items grouped together in the form of a catalog
public struct Catalog: Decodable {
    /// Array of `CatalogGroup`s
    public let groups: [CatalogGroup]
    
    enum CodingKeys: String, CodingKey {
        case groups = "groups"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.groups = try container.decode(LossyDecodableArray<CatalogGroup>.self, forKey: .groups).payload
    }
}
