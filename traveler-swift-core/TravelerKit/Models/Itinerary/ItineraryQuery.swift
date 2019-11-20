//
//  ItineraryQuery.swift
//  TravelerKit
//
//  Created by Rakin Hoque on 2019-11-20.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// A query to fetch Itinerary items
public struct ItineraryQuery {
    /// Optional flights; no flights will be returned if unspecified
    public let flights: [Flight]?
    /// Optional date range; defaults from present date to all future itinerary items
    public let dateRange: ClosedRange<Date>?
    
    /**
     Initializes an `ItineraryQuery`
     
     - Parameters:
     - flightIds: Itineraries for specific flights
     - dateRange: Denotes the duration to retrieve itineraries for
     */
    public init(flights: [Flight]?, dateRange: ClosedRange<Date>? = nil) {
        self.flights = flights
        self.dateRange = dateRange
    }
}
