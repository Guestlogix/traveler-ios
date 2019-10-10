//
//  ParkingItemSearchDelegate.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-08-07.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// Notified of catalog search results
public protocol ParkingItemSearchDelegate: class {

    /**
     Called when the `ParkingItems` were searched successfully

     - Parameters:
     - result: `ParkingItemSearchResult` filtered by search query
     - identifier: A `Hashable` identifying the request that was made. This will be the same identifier you passed to the search catalog call
     */
    func parkingItemSearchDidSucceedWith(_ result: ParkingItemSearchResult, identifier: AnyHashable?)

    /**
     Called when there was an error searching the catalog

     - Parameters:
     - error: The `Error` representing the reason for failure. No specific errors
     to look for here. Best course of action is to just display a generic error
     message.
     - identifier: A `Hashable` identifying the request that was made. This will be the same identifier you passed to the search catalog call
     */
    func parkingItemSearchDidFailWith(_ error: Error, identifier: AnyHashable?)

    /**
     Called before supplying the searched items. This is your opportunity to return any previous (paged) results
     you had so the SDK can merge them for you. Default implementation of this method returns nil.

     - Returns: Any previous `ParkingItemSearchResult` that corresponds to the same `ParkingItemSearchQuery`. nil if none
     */

    func previousResult() -> ParkingItemSearchResult?
    /**
     Called when the results have been fetched and merged. This method is called on a background thread and gives
     you the opportunity to substitute any buffering or volitile variables you may be holding. Default implementation
     of this method is a no-op.

     - Parameters:
     - result: The fetched and merged `ParkingItemSearchResult`
     - identifier: A `Hashable` identifying the request that was made. This will be same identifier
     you passed to fetch orders call.
     */
    func parkingItemSearchDidReceive(_ result: ParkingItemSearchResult, identifier: AnyHashable?)
}

public extension ParkingItemSearchDelegate {
    func previousResult() -> ParkingItemSearchResult? {
        return nil
    }

    func parkingItemSearchDidReceive(_ result: ParkingItemSearchResult, identifier: AnyHashable?) {
        // Default no-op
    }
}
