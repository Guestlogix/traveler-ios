//
//  Category.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-07-19.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation
/// Represents the different categories a `CatalogItem` can have
public enum Category: String, Decodable {
    case activity = "Activity"
    case tour = "Tour"
    case show = "Show"
    case event = "Event"
    case transfer = "Transfers"
    case parking = "Parking"
    case nightlife = "Nightlife"
    case dining = "Dining"
}
