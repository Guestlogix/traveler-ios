//
//  WishlistToggleError.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-09-03.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public enum WishlistToggleError: Error {
    /// The traveler is not identified yet. Developer must call `Traveler.identify()` before attempting to wishlsit or unwishlist an item.
    case unidentifiedTraveler
}

extension WishlistToggleError: LocalizedError{
    public var errorDescription: String? {
        switch self {
        case .unidentifiedTraveler:
            return NSLocalizedString("wishlistToggleUnidentifiedTraveler", value: "You have to login first to be able to wishlist this product", comment: "Traveler is not idenitified yet. Call Traveler.identify() before attempting to fetch the wishlist [wishlistUnidentifiedTraveler]")
        }
    }
}
