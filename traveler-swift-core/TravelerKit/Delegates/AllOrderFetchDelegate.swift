//
//  AllOrderFetchDelegate.swift
//  TravelerKit
//
//  Created by Dorothy Fu on 2019-04-25.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// Notified of order search results
public protocol AllOrderFetchDelegate: class {
    /**
     Called when the `OrderGroup` was created successfully

     - Parameters:
     - orderGroup: Created `OrderGroup`
     */
    func allOrderFetchDidSucceed(_ orderGroup: OrderGroup)
    /**
     Called when there was an error creating the orderGroup

     - Parameters:
     - error: The `Error` representing the reason for failure. No specific errors
     to look for here. Best course of action is to just display a generic error
     message.
     */
    func allOrderFetchDidFail(_ error: Error)
}
