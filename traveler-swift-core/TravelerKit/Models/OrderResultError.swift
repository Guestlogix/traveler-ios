//
//  OrderResultError.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-05-06.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// Errors that can occur upon fetching `Order`s
public enum OrderResultError: Error {
    /// The traveler is not identified yer. Developer must call `Traveler.identify()` before attempting to fetch orders
    case unidentifiedTraveler
}
