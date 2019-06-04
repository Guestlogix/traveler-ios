//
//  CancellationDelegate.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-05-27.
//  Copyright © 2019 GuestLogix Inc. All rights reserved.
//

import Foundation

/// Notified of the cancellation results
public protocol CancellationDelegate: class {
    /**
     Called when the `Order` was cancelled successfully
      - Parameters:
     -order: The `Order`that was cancelled
     */
    func cancellationDidSucceed(_ order: Order)
    /**
     Called when there was an error cancelling the `Order`

     - Parameters:
     - error: The `Error` representing the reason for failure. A `CancellationError.expiredQuote` represents
     a quote that is expired and can no longer be cancelled. It is advised to prompt the user to refetch a new quote.
     */
    func cancellationDidFailWith(_ error: Error)
}
