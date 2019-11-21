//
//  ItineraryItemType+PurchaseType.swift
//  TravelerKitUI
//
//  Created by Rakin Hoque on 2019-12-06.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit

// TODO: Remove this exension once `Product` is added to `ItineraryItem`
extension ItineraryItemType {
    var purchaseType: PurchaseType? {
        switch self {
        case .booking:
            return .booking
        case .parking:
            return .parking
        case .transportation, .flight:
            return .none
        }
    }
}
