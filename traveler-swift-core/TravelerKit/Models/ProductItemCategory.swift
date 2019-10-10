//
//  ProductItemCategory.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-07-19.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

/**
 TODO: Catalog item categories should be specific to Product type
 */
import Foundation
/// Represents the different categories a `ProductItem` can have
public enum ProductItemCategory: String, Decodable {
    case activity = "Activity"
    case tour = "Tour"
    case show = "Show"
    case event = "Event"
    case nightlife = "Nightlife"
}
