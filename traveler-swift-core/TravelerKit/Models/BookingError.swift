//
//  BookingError.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-02-08.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// Different errors a booking can have
public enum BookingError: Error {
    /// Date was not supplied
    case noDate
    /// The requested date is unavailable
    case badDate
    /// The `BookingOption` is required and was not supplied
    case noOption
    /// The requested number of passes is not available
    case noPasses
    /// Cutoff age exceeded, the age for adult passes is too old
    case veryOldTraveler
    /// The age for adult pass is invalid
    case adultAgeInvalid
    /// The requested number of units is below the minimum
    case belowMinUnits
    /// Children are not allowed without adults
    case unaccompaniedChildren
}

extension BookingError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badDate:
            return NSLocalizedString("badDateBookingError", value: "Requested date is not available", comment: "Unavailable Date")
        case .noDate:
            return NSLocalizedString("noDateBookingError", value: "Missing booking date", comment: "Missing Date")
        case .noPasses:
            return NSLocalizedString("noPassesBookingError", value: "The number of passes exceeds the maximum allowed quantity. Please adjust the number of passes to continue.", comment: "Unavailable Passes")
        case .noOption:
            return NSLocalizedString("noOptionBookingError", value: "Missing booking option", comment: "No booking option")
        case .veryOldTraveler:
            return NSLocalizedString("veryOldTravelerBookingError", value: "Cut off age exceeded, traveler is too senior for this product", comment: "Cut off age exceeded")
        case .adultAgeInvalid:
            return NSLocalizedString("adultAgeInvalidBookingError", value: "The age for adult pass is invalid", comment: "Adult age invalid")
        case .belowMinUnits:
            return NSLocalizedString("belowMinUnitsBookingError", value: "The requested number of passes is not enough. Please add more passes", comment: "Below minimum number of units")
        case .unaccompaniedChildren:
            return NSLocalizedString("unacommpaniedChildrenBookingError", value: "Children must be accompanied by an adult. Please adjust the number of passes to continue.", comment: "Unaccompanied children not allowed")
        }
    }
}
