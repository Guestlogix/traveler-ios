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
}
