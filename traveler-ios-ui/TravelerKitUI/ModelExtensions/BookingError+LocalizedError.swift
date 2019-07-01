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
        }
    }
}
