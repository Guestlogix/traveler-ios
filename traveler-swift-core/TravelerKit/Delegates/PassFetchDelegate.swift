//
//  PassFetchDelegate.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-12-05.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

/// Notified of pass fetch results
public protocol PassFetchDelegate: class {
    /**
     Called when the `Pass`es were fetched successfully

     - Parameters:
     - result: Fetched `Array<Pass>`
     */
    func passFetchDidSucceedWith(_ result: [Pass])
    /**
     Called when there was an error fetching the passes

     - Parameters:
     - error: The `Error` representing the reason for failure. No specific errors
     to look for here. Best course of action is to just display a generic error
     message.
     */
    func passFetchDidFailWith(_ error: Error)
}
