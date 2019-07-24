//
//  BookingError+LocalizedError.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-07-01.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit

extension BookingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badDate:
            return NSLocalizedString("Requested date is not available", comment: "Unavailable Date")
        case .noDate:
            return NSLocalizedString("Missing booking date", comment: "Missing Date")
        case .noPasses:
            return NSLocalizedString("Requested number of passes is not available", comment: "Unavailable Passes")
        case .noOption:
            return NSLocalizedString("Missing booking option", comment: "No booking option")
        case .veryOldTraveler:
            return NSLocalizedString("Cut off age exceeded, traveler is too senior for this product", comment: "Cut off age exceeded")
        case .adultAgeInvalid:
            return NSLocalizedString("The age for adult pass is invalid", comment: "Adult age invalid")
        case .belowMinUnits:
            return NSLocalizedString("The requested number of units is not enough", comment: "Below minimum number of units")
        case .unaccompaniedChildren:
            return NSLocalizedString("Children are not allowed without adults", comment: "Unaccompanied children not allowed")
        }
    }
}
