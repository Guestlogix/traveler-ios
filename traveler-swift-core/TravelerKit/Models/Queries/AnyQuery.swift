//
//  AnyQuery.swift
//  TravelerKit
//
//  Created by Josip Petric on 19/03/2020.
//  Copyright © 2020 Guestlogix. All rights reserved.
//

import Foundation

/// A query of any kind
public struct AnyQuery: Decodable {
    public let searchQuery: SearchQuery
    
    enum CodingKeys: String, CodingKey {
        case type = "type"
        case searchParams = "searchParams"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let type = try container.decode(QueryType.self, forKey: .type)
        switch type {
        case .booking:
            let queryParams = try container.decode(BookingItemSearchParameters.self, forKey: .searchParams)
            let bookingQuery = BookingItemQuery(with: queryParams)
            self.searchQuery = .booking(bookingQuery)
        case .parking:
            let queryParams = try container.decode(ParkingItemSearchParameters.self, forKey: .searchParams)
            let parkingQuery = ParkingItemQuery(with: queryParams)
            self.searchQuery = .parking(parkingQuery)
        }
    }
}
