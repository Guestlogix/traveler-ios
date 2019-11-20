//
//  ItineraryResult.swift
//  TravelerKit
//
//  Created by Rakin Hoque on 2019-11-20.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/**
 A result model representing the `ItineraryItem`s that were fetched for a given `ItineraryQuery`
 */
public struct ItineraryResult: Decodable {
    /// Date in which earliest itinerary item is available
    public let fromDate: Date?
    /// Date in which latest itinerary item is available
    public let toDate: Date?
    /// An `[ItineraryItem]` representing results of the query
    public let items: [ItineraryItem]
}
