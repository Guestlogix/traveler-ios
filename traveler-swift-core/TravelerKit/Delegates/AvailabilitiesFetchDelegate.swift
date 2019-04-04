//
//  AvailabilitiesFetchDelegate.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-03-12.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// Notified of availabilities fetch results
public protocol AvailabilitiesFetchDelegate: class {
    /**
     Called when there was as error fetching the availaibilies

     - Parameters:
     - error: The `Error` representing the reason for failure. No specific errors
     to look for here. Best coarse of action is to just display a generic error
     message.
     */
    func availabilitiesFetchDidFailWith(_ error: Error)
    /**
     Called when the availabilities were successfully fetched

     - Parameters:
     - availabilities: Fetched `Array<Availability>`
     */
    func availabilitiesFetchDidSucceedWith(_ availabilities: [Availability])
}
