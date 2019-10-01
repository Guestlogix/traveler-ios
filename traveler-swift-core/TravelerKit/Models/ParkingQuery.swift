//
//  ParkingQuery.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-10-05.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// A query to fetch Parking items
public struct ParkingQuery {
    /// Pagination offset
    public let offset: Int
    /// Pagination limit
    public let limit: Int
    /// IATA code as string for aiport oriented queries
    public let airportIATA: String?
    /// A range of dates where parking is available
    public let dateRange: ClosedRange<Date>
    /// A `BoundingBox` representing the geographic area in which items should be searched for
    public let boundingBox: BoundingBox?

    /**
     Initializes a `ParkingQuery`
     - Parameters:
     - An `Int` for pagination offset
     - An `Int` for page size
     - An optional `String` for airport queries
     - An `ClosedRange<Date>` fot dates
     - An optional `BoundingBox`
     - Returns: `ParkingQuery`
     */

    public init(offset: Int = 0, take: Int = 10, airport: String?, range: ClosedRange<Date>,  boundingBox: BoundingBox?) {
        self.offset = offset
        self.limit = take
        self.dateRange = range
        self.boundingBox = boundingBox
        self.airportIATA = airport
    }

    init(with params: ParkingSearchParameters) {
        self.boundingBox = params.boundingBox
        self.dateRange = params.dateRange
        self.airportIATA = params.airportIATA
        self.offset = 0
        self.limit = 10
    }

}

extension ParkingQuery: Equatable {
    public static func == (lhs: ParkingQuery, rhs: ParkingQuery) -> Bool {
        return lhs.boundingBox == rhs.boundingBox && lhs.dateRange == rhs.dateRange && lhs.airportIATA == rhs.airportIATA
    }
}

