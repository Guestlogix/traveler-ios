//
//  Product+Description.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-06-07.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit

extension Product {
    var secondaryDescription: String? {
        switch self {
        case let self as BookingProduct:
            return ISO8601DateFormatter.dateOnlyFormatter.string(from: self.eventDate)
        case let self as ParkingProduct:
            return ISO8601DateFormatter.dateOnlyFormatter.string(from: self.eventDate)
        default:
            return nil
        }
    }
}

