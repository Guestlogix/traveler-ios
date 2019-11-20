//
//  ItineraryFetchDelegate.swift
//  TravelerKit
//
//  Created by Rakin Hoque on 2019-11-20.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// Notified of the ItineraryResult fetch
public protocol ItineraryFetchDelegate: class {
    /**
     Called when the results have successfully been fetched

     - Parameters:
     - result: The `ItineraryResult` that was fetched and merged
     */
    func itineraryFetchDidSucceedWith(_ result: ItineraryResult)
    /**
     Called when there was an error fetching the results

     - Parameters:
     - error: The `Error` that caused the issue
     */
    func itineraryFetchDidFailWith(_ error: Error)
}
