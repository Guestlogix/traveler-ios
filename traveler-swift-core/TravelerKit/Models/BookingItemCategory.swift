//
//  BookingItemCategory.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-07-19.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation
/// Represents the different categories a `BookingItem` can have
public enum BookingItemCategory: String, Decodable, CaseIterable {
    case activity = "Activity"
    case tour = "Tour"
    case show = "Show"
    case event = "Event"
    case nightlife = "Nightlife"
}
