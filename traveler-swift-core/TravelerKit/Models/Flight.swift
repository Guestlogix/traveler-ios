//
//  Flight.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-09-13.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

/// Represents information about a flight
public struct Flight: Codable, Equatable {
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
    // TODO: Terminals should be part of the `Airport` model
    /// Departure terminal
    public let departureTerminal: String?
    /// Arrival terminal
    public let arrivalTerminal: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case number = "flightNumber"
        case departureAirport = "origin"
        case arrivalAirport = "destination"
        case departureDate = "departureTime"
        case arrivalDate = "arrivalTime"
        case departureTerminal = "departureTerminal"
        case arrivalTerminal = "arrivalTerminal"
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(number, forKey: .number)
        try container.encode(departureAirport, forKey: .departureAirport)
        try container.encode(arrivalAirport, forKey: .arrivalAirport)
        try container.encode(departureTerminal, forKey: .departureTerminal)
        try container.encode(arrivalTerminal, forKey: .arrivalTerminal)

        let formatter = DateFormatter()
        let formatterDeparture = formatter.fullFormatter(with: departureAirport.timeZone)
        let departureDateString = formatterDeparture.string(from: departureDate)
        try container.encode(departureDateString, forKey: .departureDate)

        let formatterArrival = formatter.fullFormatter(with: arrivalAirport.timeZone)
        let arrivalDateString = formatterArrival.string(from: arrivalDate)
        try container.encode(arrivalDateString, forKey: .arrivalDate)
    }

    init(id: String, number: String, departureAirport: Airport, arrivalAirport: Airport, departureDate: Date, arrivalDate: Date, departureTerminal: String, arrivalTerminal: String) {
        self.id = id
        self.number = number
        self.departureAirport = departureAirport
        self.arrivalAirport = arrivalAirport
        self.departureDate = departureDate
        self.arrivalDate = arrivalDate
        self.departureTerminal = departureTerminal
        self.arrivalTerminal = arrivalTerminal
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.number = try container.decode(String.self, forKey: .number)
        self.id = try container.decode(String.self, forKey: .id)
        self.departureTerminal = try container.decode(String?.self, forKey: .departureTerminal)
        self.arrivalTerminal = try container.decode(String?.self, forKey: .arrivalTerminal)

        let departureAirport = try container.decode(Airport.self, forKey: .departureAirport)
        let arrivalAirport = try container.decode(Airport.self, forKey: .arrivalAirport)

        self.departureAirport = departureAirport
        self.arrivalAirport = arrivalAirport

        let formatter = DateFormatter()
        
        let departureDateString = try container.decode(String.self, forKey: .departureDate)
        let formatterDeparture = formatter.fullFormatter(with: departureAirport.timeZone)
        guard let departureDate = formatterDeparture.date(from: departureDateString) else {
            throw DecodingError.dataCorruptedError(forKey: .departureDate, in: container, debugDescription: "Date string does not match expected format for departure date.")
        }

        let arrivalDateString = try container.decode(String.self, forKey: .arrivalDate)
        let formatterArrival = formatter.fullFormatter(with: arrivalAirport.timeZone)
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
