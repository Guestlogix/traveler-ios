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

    init(id: String, number: String, departureAirport: Airport, arrivalAirport: Airport, departureDate: Date, arrivalDate: Date) {
        self.id = id
        self.number = number
        self.departureAirport = departureAirport
        self.arrivalAirport = arrivalAirport
        self.departureDate = departureDate
        self.arrivalDate = arrivalDate
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.number = try container.decode(String.self, forKey: .number)
        self.id = try container.decode(String.self, forKey: .id)

        let departureAirport = try container.decode(Airport.self, forKey: .departureAirport)
        let arrivalAirport = try container.decode(Airport.self, forKey: .arrivalAirport)

        self.departureAirport = departureAirport
        self.arrivalAirport = arrivalAirport

        let departureDateString = try container.decode(String.self, forKey: .departureDate)
        let formatterDeparture = DateFormatter.dateFormatter(with: departureAirport.timeZone)
        guard let departureDate = formatterDeparture.date(from: departureDateString) else {
            throw DecodingError.dataCorruptedError(forKey: .departureDate, in: container, debugDescription: "Date string does not match expected format for departure date.")
        }

        let arrivalDateString = try container.decode(String.self, forKey: .arrivalDate)
        let formatterArrival = DateFormatter.dateFormatter(with: arrivalAirport.timeZone)
        guard let arrivalDate = formatterArrival.date(from: arrivalDateString) else {
            throw DecodingError.dataCorruptedError(forKey: .departureDate, in: container, debugDescription: "Date string does not match expected format for arrival date.")
        }

        self.departureDate = departureDate
        self.arrivalDate = arrivalDate
    }

    /**
     Returns departure date as a string given a `DateFormatter`

     - Parameters:
     - dateFormatter: The `DateFormatter` that formats the string

     - Returns: A string describing the departure date
     */
    public func departureDateDescription(with dateFormatter: DateFormatter) -> String {
        return departureDate.description(with: departureAirport.timeZone, formatter: dateFormatter)
    }

    /**
     Returns arrival date as a string given a `DateFormatter`

     - Parameters:
     - dateFormatter: The `DateFormatter` that formats the string

     - Returns: A string describing the arrival date
     */
    public func arrivalDateDescription(with dateFormatter: DateFormatter) -> String {
        return arrivalDate.description(with: arrivalAirport.timeZone, formatter: dateFormatter)
    }
}
