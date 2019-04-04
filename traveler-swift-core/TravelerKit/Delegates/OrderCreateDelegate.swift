//
//  OrderCreateDelegate.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-01-25.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// Notified of order creation results
public protocol OrderCreateDelegate: class {
    /**
     Called when the `Order` was created successfully

     - Parameters:
     - order: Created `Order`
     */
    func orderCreationDidSucceed(_ order: Order)
    /**
     Called when there was an error creating the order

     - Parameters:
     - error: The `Error` representing the reason for failure. No specific errors
     to look for here. Best course of action is to just display a generic error
     message.
     */
    func orderCreationDidFail(_ error: Error)
}
