//
//  Flight.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-09-13.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

/**
 {
     "flightNumber": "string",
     "originId": "string",
     "destinationId": "string",
     "origin": {
         "name": "string",
         "iataCode": "string",
         "longitude": 0,
         "latitude": 0,
         "address": "string",
         "city": "Toronto",
         "state": {
             "name": "Ontario",
             "code": "ON"
         },
         "country": {
             "name": "Canada",
             "isoCode": "CA",
             "region": "North America"
         }
     },
     "destination": {
         "name": "string",
         "iataCode": "string",
         "longitude": 0,
         "latitude": 0,
         "address": "string",
         "city": "Toronto",
         "state": {
             "name": "Ontario",
             "code": "ON"
         },
         "country": {
             "name": "Canada",
             "isoCode": "CA",
             "region": "North America"
         }
     },
     "stops": 0,
     "departureTerminal": "string",
     "arrivalTerminal": "string",
     "departureTime": "2018-10-19T13:51:02.308",
     "arrivalTime": "2018-10-19T13:51:02.308",
     "isCodeShare": true
 }
 **/

public struct Flight: Decodable {
    public let number: String
    public let departureAirport: Airport
    public let arrivalAirport: Airport
    public let departureDate: Date
    public let arrivalDate: Date

    enum CodingKeys: String, CodingKey {
        case number = "flightNumber"
        case departureAirport = "origin"
        case arrivalAirport = "destination"
        case departureDate = "departureTime"
        case arrivalDate = "arrivalTime"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.number = try container.decode(String.self, forKey: .number)

        let departureDateString = try container.decode(String.self, forKey: .departureDate)
        guard let departureDate = DateFormatter.withoutTimezone.date(from: departureDateString) else {
            throw DecodingError.dataCorruptedError(forKey: .departureDate, in: container, debugDescription: "Date string does not match expected format.")
        }

        let arrivalDateString = try container.decode(String.self, forKey: .arrivalDate)
        guard let arrivalDate = DateFormatter.withoutTimezone.date(from: arrivalDateString) else {
            throw DecodingError.dataCorruptedError(forKey: .arrivalDate, in: container, debugDescription: "Date string does not match expeted format.")
        }

        self.departureDate = departureDate
        self.arrivalDate = arrivalDate
        self.departureAirport = try container.decode(Airport.self, forKey: .departureAirport)
        self.arrivalAirport = try container.decode(Airport.self, forKey: .arrivalAirport)
    }
}
