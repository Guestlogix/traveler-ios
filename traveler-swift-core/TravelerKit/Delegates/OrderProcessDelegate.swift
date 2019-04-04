//
//  OrderProcessDelegate.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-02-01.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// Notified of `Order` processing results
public protocol OrderProcessDelegate: class {
    /**
     Called when the `Order` was processed successfully

     - Parameters:
     - order: Created `Order`
     - receipt: A `Receipt` as confirmation that the `Order` was processed
     */
    func order(_ order: Order, didSucceedWithReceipt receipt: Receipt)
    /**
     Called when there was as error processing the order

     - Parameters:
     - error: The `Error` representing the reason for failure. No specific errors
     to look for here. Best coarse of action is to just display a generic error
     message.
     */
    func order(_ order: Order, didFailWithError error: Error)
}
