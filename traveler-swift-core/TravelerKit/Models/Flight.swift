//
//  Flight.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-09-13.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

/// Represents information about a flight
public struct Flight: Decodable, Equatable {
    public static func == (lhs: Flight, rhs: Flight) -> Bool {
        return lhs.id == rhs.id
        && lhs.number == rhs.number
        && lhs.departureAirport == rhs.departureAirport
        && lhs.arrivalAirport == rhs.arrivalAirport
        && lhs.departureDate == rhs.departureDate
    }

    /// Identifier
    public let id: String
    /// Flightnumber
    public let number: String
    /// Departing airport
    public let departureAirport: Airport
    /// Arriving airport
    public let arrivalAirport: Airport
    /// Departure time
    public let departureDate: Date
    /// Arrival time
    public let arrivalDate: Date

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case number = "flightNumber"
        case departureAirport = "origin"
        case arrivalAirport = "destination"
        case departureDate = "departureTime"
        case arrivalDate = "arrivalTime"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.number = try container.decode(String.self, forKey: .number)
        self.id = try container.decode(String.self, forKey: .id)

        let departureDateString = try container.decode(String.self, forKey: .departureDate)
        guard let departureDate = DateFormatter.withoutTimezone.date(from: departureDateString) else {
            throw DecodingError.dataCorruptedError(forKey: .departureDate, in: container, debugDescription: "Date string does not match expected format.")
        }

        let arrivalDateString = try container.decode(String.self, forKey: .arrivalDate)
        guard let arrivalDate = DateFormatter.withoutTimezone.date(from: arrivalDateString) else {
            throw DecodingError.dataCorruptedError(forKey: .arrivalDate, in: container, debugDescription: "Date string does not match expected format.")
        }

        self.departureDate = departureDate
        self.arrivalDate = arrivalDate
        self.departureAirport = try container.decode(Airport.self, forKey: .departureAirport)
        self.arrivalAirport = try container.decode(Airport.self, forKey: .arrivalAirport)
    }
}
