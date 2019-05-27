//
//  OrderFetchDelegate.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-05-06.
//  Copyright © 2019 Guestlogix Inc. All rights reserved.
//

import Foundation

/// Notified of the OrderResult fetch
public protocol OrderFetchDelegate: class {
    /**
     Called when the results have successfully been fetched

     - Parameters:
     - result: The `OrderResult` that was fetched and merged
     - identifier: A `Hashable` identifying the request that was made. This will be same identifier
        you passed to fetch orders call.
     */
    func orderFetchDidSucceedWith(_ result: OrderResult, identifier: AnyHashable?)
    /**
     Called when there was an error fetching the results

     - Parameters:
     - error: The `Error` that caused the issue
     - identifier: A `Hashable` identifying the request that was made. This will be same identifier
     you passed to fetch orders call.
     */
    func orderFetchDidFailWith(_ error: Error, identifier: AnyHashable?)
    /**
     Called before supplying the fetched results. This is your opportunity to return any previous (paged) results
     you had so the SDK can merge them for you. Default implementation of this method returns nil.

     - Returns: Any previous `OrderResult` that corresponds to the same `OrderQuery`. nil if none
     */
    func previousResult() -> OrderResult?
    /**
     Called when the results have been fetched and merged. This method is called on a background thread and gives
     you the opportunity to substitute any buffering or volitile variables you may be holding. Default implementation
     of this method is a no-op.

     - Parameters:
     - result: The fetched and merged `OrderResult`
     - identifier: A `Hashable` identifying the request that was made. This will be same identifier
     you passed to fetch orders call.
     */
    func orderFetchDidReceive(_ result: OrderResult, identifier: AnyHashable?)
}

public extension OrderFetchDelegate {
    func previousResult() -> OrderResult? {
        return nil
    }

    func orderFetchDidReceive(_ result: OrderResult, identifier: AnyHashable?) {
        // Default no-op
    }
}
