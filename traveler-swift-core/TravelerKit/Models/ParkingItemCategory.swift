//
//  ParkingItemCategory.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-10-09.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation
/// Represents the different categories a `BookingItem` can have
//TODO: Change category items in this enum to be parking specific. 
public enum ParkingItemCategory: String, Decodable {
    case activity = "Activity"
    case tour = "Tour"
    case show = "Show"
    case event = "Event"
    case nightlife = "Nightlife"
}
