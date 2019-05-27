//
//  CancellationQuoteFetchDelegate.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-05-27.
//  Copyright © 2019 GuestLogix Inc. All rights reserved.
//

import Foundation

/// Notified of CancelationQuote fetch results
public protocol CancellationQuoteFetchDelegate: class {
    /**
     Called when the `CancellationQuote` was fetched successfully

     - Parameters:
     - quote: Fetched `CancellationQuote`
     */
    func cancellationQuoteFetchDidSucceedWith(_ quote: CancellationQuote)
    /**
     Called when there was an error fetching the quote

     - Parameters:
     - error: The `Error` representing the reason for failure. No specific errors
     to look for here. Best course of action is to just display a generic error
     message.
     */
    func cancellationQuoteFetchDidFailWith(_ error: Error)
}
