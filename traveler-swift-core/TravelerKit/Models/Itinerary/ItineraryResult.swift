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
    
    enum CodingKeys: String, CodingKey {
        case fromDate = "from"
        case toDate = "to"
        case items = "items"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.items = try container.decode(LossyDecodableArray<ItineraryItem>.self, forKey: .items).payload
        
        let fromDateString = try container.decode(String.self, forKey: .fromDate)
        
        if let fromDate = DateFormatter.dateOnlyFormatter.date(from: fromDateString) {
            self.fromDate = fromDate
        } else {
            self.fromDate = nil
        }
        
        let toDateString = try container.decode(String.self, forKey: .toDate)
        
        if let toDate = DateFormatter.dateOnlyFormatter.date(from: toDateString) {
            self.toDate = toDate
        } else {
            self.toDate = nil
        }
    }
}
