//
//  WishlistFetchDelegate.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-09-03.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// Notified of the WishlistResult fetch
public protocol WishlistFetchDelegate: class {
    /**
     Called when the results have successfully been fetched

     - Parameters:
     - result: The `WishlistResult` that was fetched and merged
     - identifier: A `Hashable` identifying the request that was made. This will be same identifier
     you passed to fetch wishlist call.
     */
    func wishlistFetchDidSucceedWith(_ result: WishlistResult, identifier: AnyHashable?)
    /**
     Called when there was an error fetching the results

     - Parameters:
     - error: The `Error` that caused the issue
     - identifier: A `Hashable` identifying the request that was made. This will be same identifier
     you passed to fetch wishlist call.
     */
    func wishlistFetchDidFailWith(_ error: Error, identifier: AnyHashable?)
    /**
     Called before supplying the fetched results. This is your opportunity to return any previous (paged) results
     you had so the SDK can merge them for you. Default implementation of this method returns nil.

     - Returns: Any previous `WishlistResult` that corresponds to the same `WishlistQuery`. nil if none
     */
    func previousResult() -> WishlistResult?
    /**
     Called when the results have been fetched and merged. This method is called on a background thread and gives
     you the opportunity to substitute any buffering or volitile variables you may be holding. Default implementation
     of this method is a no-op.

     - Parameters:
     - result: The fetched and merged `WishlistResult`
     - identifier: A `Hashable` identifying the request that was made. This will be same identifier
     you passed to fetch wishlist call.
     */
    func wishlistFetchDidReceive(_ result: WishlistResult, identifier: AnyHashable?)
}

public extension WishlistFetchDelegate {
    func previousResult() -> WishlistResult? {
        return nil
    }

    func wishlistFetchDidReceive(_ result: WishlistResult, identifier: AnyHashable?) {
        // Default no-op
    }
}
