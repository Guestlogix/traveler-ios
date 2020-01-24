//
//  ParkingItemSearchParameters.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-10-05.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation
/// A model containing the search parameters of a `ParkingQuery`
public struct ParkingItemSearchParameters: Decodable {
    /// An airport IATA code that represents the airport for which to search available parking
    public var airportIATA: String?
    /// A `BoundingBox` specifying the area to search for available parking
    public var boundingBox: BoundingBox?
    /// A range of dates where parking is available
    public var dateRange: ClosedRange<Date>

    enum CodingKeys: String, CodingKey {
        case airport = "airport"
        case topLeftLatitude = "topLeftLatitude"
        case topLeftLongitude = "topLeftLongitude"
        case bottomRightLatitude = "bottomRightLatitude"
        case bottomRightLongitude = "bottomRightLongitude"
        case startTime = "startTime"
        case endTime = "endTime"

    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.airportIATA = try container.decode(String?.self, forKey: .airport)

        if let topLeftLatitude = try container.decode(Double?.self, forKey: .topLeftLatitude),
            let topLeftLongitude = try container.decode(Double?.self, forKey: .topLeftLongitude),
            let bottomRightLatitude = try container.decode(Double?.self, forKey: .bottomRightLatitude),
            let bottomRighLongitude = try container.decode(Double?.self, forKey: .bottomRightLongitude) {

            let topLeftCoordinate = Coordinate(latitude: topLeftLatitude, longitude: topLeftLongitude)
            let bottomRightCoordinate = Coordinate(latitude: bottomRightLatitude, longitude: bottomRighLongitude)

            self.boundingBox = BoundingBox(topLeftCoordinate: topLeftCoordinate, bottomRightCoordinate: bottomRightCoordinate)
        } else {
            self.boundingBox = nil
        }

        let startTimeString = try container.decode(String.self, forKey: .startTime)
        let endTimeString = try container.decode(String.self, forKey: .endTime)

        if let startTime = DateFormatter.withoutTimezoneGregorian.date(from: startTimeString),
            let endTime = DateFormatter.withoutTimezoneGregorian.date(from: endTimeString) {
            self.dateRange = startTime...endTime
        } else {
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.startTime, in: container, debugDescription: "Wrong date format for to and from dates")
        }
    }
}
