//
//  WishlistToggleError+LocalizedError.swift
//  TravelerKitUI
//
//  Created by Ben Ruan on 2019-09-16.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit

extension WishlistToggleError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unidentifiedTraveler:
            return NSLocalizedString("You have to login first to wishlist items.", comment: "User not logged ")
        case .notInWishlist:
            return NSLocalizedString("You are trying to remove something not exist in your local wishlist.", comment: "")
        }
    }
}
