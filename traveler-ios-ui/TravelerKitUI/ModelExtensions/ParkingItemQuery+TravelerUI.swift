//
//  ParkingItemQuery+TravelerUI.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-10-28.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit

extension ParkingItemQuery {
    var datesDescription: String {
        return "\(DateFormatter.shortDisplayFormatter.string(from: dateRange.lowerBound)) - \(DateFormatter.shortDisplayFormatter.string(from: dateRange.upperBound))"
    }
}
