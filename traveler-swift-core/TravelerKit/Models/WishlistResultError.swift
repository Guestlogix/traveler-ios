//
//  WishlistResultError.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-09-03.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation
/// Errors that can occur upon fetching the Wishlist
public enum WishlistResultError: Error {
    /// The traveler is not identified yer. Developer must call `Traveler.identify()` before attempting to fetch the wishlist
    case unidentifiedTraveler
    case resultMismatch
}
