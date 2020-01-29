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
    /// The traveler is not identified yet. Developer must call `Traveler.identify()` before attempting to fetch the wishlist
    case unidentifiedTraveler
    /// The local wishlist result doesn't match the wishlist result from the server. 
    case resultMismatch

    public var errorDescription: String? {
        switch self {
        case .unidentifiedTraveler:
            return NSLocalizedString("wishlistUnidentifiedTraveler", tableName: nil, value: "You have to login first to get your wishlist", comment: "Traveler is not idenitified yet. Call Traveler.identify() before attempting to fetch the wishlist")
        case .resultMismatch:
            return NSLocalizedString("wishlistResultMisMatch", tableName: nil, value: "Sorry something went wrong while wishlisting this product", comment: "Local wishlist result doesnt match the wishlist result from server")
        }
    }
}
