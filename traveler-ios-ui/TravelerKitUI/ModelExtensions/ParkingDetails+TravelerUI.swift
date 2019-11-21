//
//  ParkingDetails+TravelerUI.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-10-28.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit

// TODO: Make a utilitity class to handle common formatting rather than extending specific models to handle the same thing
extension ParkingItemDetails {
    var datesDescription: String {
        return "\(DateFormatter.shortDisplayFormatter.string(from: dateRange.lowerBound)) - \(DateFormatter.shortDisplayFormatter.string(from: dateRange.upperBound))"
    }
}

extension PurchasedParkingProductDetails {
    var datesDescription: String {
        return "\(DateFormatter.shortDisplayFormatter.string(from: dateRange.lowerBound)) - \(DateFormatter.shortDisplayFormatter.string(from: dateRange.upperBound))"
    }
}
