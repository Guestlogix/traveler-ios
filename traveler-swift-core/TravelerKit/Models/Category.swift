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
    case Activity
    case Tour
    case Show
    case Event
    case Transfer
    case Parking
    case Nightlife
    case Dining
}
