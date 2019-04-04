//
//  FlightSeachDelegate.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-10-17.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

/// Notified of flight search results
public protocol FlightSearchDelegate: class {
    /**
     Called when results were successfully retreived

     - Parameters:
     - result: The `Array<Flight>` matching the query
     */
    func flightSearchDidSucceedWith(_ result: [Flight])
    /**
     Called when there was an error retreiving results

     - Parameters:
     - error: The `Error` representing the reason for failure. No specific error
        to look for here, best coarse of action is to just display a generic error
        message.
     */
    func flightSearchDidFailWith(_ error: Error)
}
