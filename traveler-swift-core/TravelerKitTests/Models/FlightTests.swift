//
//  FlightTests.swift
//  TravelerKitTests
//
//  Created by Omar Padierna on 2019-07-11.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import XCTest
@testable import TravelerKit

class FlightTests: XCTestCase {
    func testDepartureDescription() {
        //given
        let departureAirportTimezone = TimeZone(secondsFromGMT: -18000)!
        let departureAirport = Airport(code: "MEX", name: "Benito Juarez International Airport", city: "Mexico City", timeZone: departureAirportTimezone)
        let departureDate = Date(timeIntervalSince1970: 1565499900) // August 11, 2019 00:05:00 in Mexico City

        let arrivalAirportTimezone = TimeZone(secondsFromGMT: -14400)!
        let arrivalAirport = Airport(code: "YYZ", name: "Pearson International Airport", city: "Toronto", timeZone: arrivalAirportTimezone)
        let arrivalDate = Date(timeIntervalSince1970: 1565514300) //August 11, 2019 05:05:00 in Toronto

        let flight = Flight(id: "Test", number: "AC1981", departureAirport: departureAirport, arrivalAirport: arrivalAirport, departureDate: departureDate, arrivalDate: arrivalDate)

        //when
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        //then
        XCTAssert(flight.departureDateDescription(with: dateFormatter) == "2019-08-11T00:05:00")
    }

    func testArrivalDescription() {
        //given
        let departureAirportTimezone = TimeZone(secondsFromGMT: -18000)!
        let departureAirport = Airport(code: "MEX", name: "Benito Juarez International Airport", city: "Mexico City", timeZone: departureAirportTimezone)
        let departureDate = Date(timeIntervalSince1970: 1565499900) // 00:05:00 in Mexico City

        let arrivalAirportTimezone = TimeZone(secondsFromGMT: -14400)!
        let arrivalAirport = Airport(code: "YYZ", name: "Pearson International Airport", city: "Toronto", timeZone: arrivalAirportTimezone)
        let arrivalDate = Date(timeIntervalSince1970: 1565514300) // 05:05:00 in Toronto

        let flight = Flight(id: "Test", number: "AC1981", departureAirport: departureAirport, arrivalAirport: arrivalAirport, departureDate: departureDate, arrivalDate: arrivalDate)

        //when
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        //then
        XCTAssert(flight.arrivalDateDescription(with: dateFormatter) == "2019-08-11T05:05:00")
    }

    func testDepartureDateFromDecoder() {
        //given
        let jsonData = "[{\"id\":\"fli_aT91nhXX7Fh91hZ9F_\",\"flightNumber\":\"AC1980\",\"origin\":{\"iata\":\"YYZ\",\"name\":\"Pearson International Airport\",\"street1\":\"\",\"street2\":\"\",\"city\":\"Toronto\",\"cityCode\":\"YTO\",\"stateCode\":\"ON\",\"postalCode\":\"L5P 1B2\",\"countryCode\":\"CA\",\"countryName\":\"Canada\",\"latitude\":43.6815834,\"longitude\":-79.61146,\"utcOffsetHours\":\"-4.0\"},\"destination\":{\"iata\":\"MEX\",\"name\":\"Benito Juarez International Airport\",\"street1\":null,\"street2\":null,\"city\":\"Mexico City\",\"cityCode\":\"MEX\",\"stateCode\":null,\"postalCode\":null,\"countryCode\":\"MX\",\"countryName\":\"Mexico\",\"latitude\":19.4352779,\"longitude\":-99.07278,\"utcOffsetHours\":\"-5.0\"},\"stops\":0,\"departureTerminal\":\"1\",\"arrivalTerminal\":\"1\",\"departureTime\":\"2019-07-12T08:30:00\",\"arrivalTime\":\"2019-07-12T12:20:00\",\"isCodeShare\":false,\"codeShares\":[{\"carrierCode\":\"AV\",\"number\":6929}]}]".data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        //when
        let flights = try! decoder.decode([Flight].self, from: jsonData)
        let flight = flights[0]
        let departureDate = Date(timeIntervalSince1970: 1562934600)

        //then
        XCTAssert(flight.departureDate == departureDate)
    }

    func testArrivalDateFromDecoder() {
        //given
        let jsonData = "[{\"id\":\"fli_aT91nhXX7Fh91hZ9F_\",\"flightNumber\":\"AC1980\",\"origin\":{\"iata\":\"YYZ\",\"name\":\"Pearson International Airport\",\"street1\":\"\",\"street2\":\"\",\"city\":\"Toronto\",\"cityCode\":\"YTO\",\"stateCode\":\"ON\",\"postalCode\":\"L5P 1B2\",\"countryCode\":\"CA\",\"countryName\":\"Canada\",\"latitude\":43.6815834,\"longitude\":-79.61146,\"utcOffsetHours\":\"-4.0\"},\"destination\":{\"iata\":\"MEX\",\"name\":\"Benito Juarez International Airport\",\"street1\":null,\"street2\":null,\"city\":\"Mexico City\",\"cityCode\":\"MEX\",\"stateCode\":null,\"postalCode\":null,\"countryCode\":\"MX\",\"countryName\":\"Mexico\",\"latitude\":19.4352779,\"longitude\":-99.07278,\"utcOffsetHours\":\"-5.0\"},\"stops\":0,\"departureTerminal\":\"1\",\"arrivalTerminal\":\"1\",\"departureTime\":\"2019-07-12T08:30:00\",\"arrivalTime\":\"2019-07-12T12:20:00\",\"isCodeShare\":false,\"codeShares\":[{\"carrierCode\":\"AV\",\"number\":6929}]}]".data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        //when
        let flights = try! decoder.decode([Flight].self, from: jsonData)
        let flight = flights[0]
        let arrivalDate = Date(timeIntervalSince1970: 1562952000)

        //then
        XCTAssert(flight.arrivalDate == arrivalDate)
    }

    func testBadArrivalDateFromDecoder() {
        //given
        let jsonData = "[{\"id\":\"fli_aT91nhXX7Fh91hZ9F_\",\"flightNumber\":\"AC1980\",\"origin\":{\"iata\":\"YYZ\",\"name\":\"Pearson International Airport\",\"street1\":\"\",\"street2\":\"\",\"city\":\"Toronto\",\"cityCode\":\"YTO\",\"stateCode\":\"ON\",\"postalCode\":\"L5P 1B2\",\"countryCode\":\"CA\",\"countryName\":\"Canada\",\"latitude\":43.6815834,\"longitude\":-79.61146,\"utcOffsetHours\":\"-4.0\"},\"destination\":{\"iata\":\"MEX\",\"name\":\"Benito Juarez International Airport\",\"street1\":null,\"street2\":null,\"city\":\"Mexico City\",\"cityCode\":\"MEX\",\"stateCode\":null,\"postalCode\":null,\"countryCode\":\"MX\",\"countryName\":\"Mexico\",\"latitude\":19.4352779,\"longitude\":-99.07278,\"utcOffsetHours\":\"-5.0\"},\"stops\":0,\"departureTerminal\":\"1\",\"arrivalTerminal\":\"1\",\"departureTime\":\"2019-07-12T08:30:00\",\"arrivalTime\":\"2019-07-12T12:20:00-05:00\",\"isCodeShare\":false,\"codeShares\":[{\"carrierCode\":\"AV\",\"number\":6929}]}]".data(using: .utf8)!

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
             //when
            let _ = try decoder.decode([Flight].self, from: jsonData)
        } catch {
            let contextString = String(reflecting: error)
            let contextStringComponents = contextString.components(separatedBy: "debugDescription: ")
            let debugDescription = contextStringComponents[1].components(separatedBy: ",")[0]
            print(debugDescription)
            //then
            XCTAssert(debugDescription == "\"Date string does not match expected format for arrival date.\"")
        }
    }

    func testBadDepartureDateFromDecoder() {
        //given
        let jsonData = "[{\"id\":\"fli_aT91nhXX7Fh91hZ9F_\",\"flightNumber\":\"AC1980\",\"origin\":{\"iata\":\"YYZ\",\"name\":\"Pearson International Airport\",\"street1\":\"\",\"street2\":\"\",\"city\":\"Toronto\",\"cityCode\":\"YTO\",\"stateCode\":\"ON\",\"postalCode\":\"L5P 1B2\",\"countryCode\":\"CA\",\"countryName\":\"Canada\",\"latitude\":43.6815834,\"longitude\":-79.61146,\"utcOffsetHours\":\"-4.0\"},\"destination\":{\"iata\":\"MEX\",\"name\":\"Benito Juarez International Airport\",\"street1\":null,\"street2\":null,\"city\":\"Mexico City\",\"cityCode\":\"MEX\",\"stateCode\":null,\"postalCode\":null,\"countryCode\":\"MX\",\"countryName\":\"Mexico\",\"latitude\":19.4352779,\"longitude\":-99.07278,\"utcOffsetHours\":\"-5.0\"},\"stops\":0,\"departureTerminal\":\"1\",\"arrivalTerminal\":\"1\",\"departureTime\":\"2019-07-12T08:30:00-04:00:00\",\"arrivalTime\":\"2019-07-12T12:20:00\",\"isCodeShare\":false,\"codeShares\":[{\"carrierCode\":\"AV\",\"number\":6929}]}]".data(using: .utf8)!

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            //when
            let _ = try decoder.decode([Flight].self, from: jsonData)
        } catch {
            let contextString = String(reflecting: error)
            let contextStringComponents = contextString.components(separatedBy: "debugDescription: ")
            let debugDescription = contextStringComponents[1].components(separatedBy: ",")[0]
            print(debugDescription)
            //then
            XCTAssert(debugDescription == "\"Date string does not match expected format for departure date.\"")
        }
    }

}
