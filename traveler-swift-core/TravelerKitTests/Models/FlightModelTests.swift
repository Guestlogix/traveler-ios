//
//  FlightModelTests.swift
//  TravelerKitTests
//
//  Created by Dorothy Fu on 2019-03-15.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import XCTest
@testable import TravelerKit

class FlightModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecodingMissingIdThrows() throws {
        AssertThrowsKeyNotFound("id", decoding: Flight.self, from: try testFlight.json(deletingKeyPaths: "id"))
    }

    func testDecodingMissingFlightNumThrows() throws {
        AssertThrowsKeyNotFound("flightNumber", decoding: Flight.self, from: try testFlight.json(deletingKeyPaths: "flightNumber"))
    }

    func testDecodingMissingOriginThrows() throws {
        AssertThrowsKeyNotFound("origin", decoding: Flight.self, from: try testFlight.json(deletingKeyPaths: "origin"))
    }

    func testDecodingMissingDestinationThrows() throws {
        AssertThrowsKeyNotFound("destination", decoding: Flight.self, from: try testFlight.json(deletingKeyPaths: "destination"))
    }

    func testDecodingMissingDepDateThrows() throws {
        AssertThrowsKeyNotFound("departureTime", decoding: Flight.self, from: try testFlight.json(deletingKeyPaths: "departureTime"))
    }

    func testDecodingMissingArrDateThrows() throws {
        AssertThrowsKeyNotFound("arrivalTime", decoding: Flight.self, from: try testFlight.json(deletingKeyPaths: "arrivalTime"))
    }
}

private let testFlight = Data("""
{
        "id": "foo",
        "flightNumber": "foo",
        "origin": {
            "iata": "JFK",
            "name": "New York",
            "street1": "foo",
            "street2": "foo",
            "city": "foo",
            "cityCode": "foo",
            "stateCode": "foo",
            "postalCode": "foo",
            "countryCode": "foo",
            "countryName": "foo",
            "latitude": 3.1415,
            "longitude": 3.1415
        },
        "destination": {
            "iata": "YYZ",
            "name": "Turranah",
            "street1": "foo",
            "street2": "foo",
            "city": "foo",
            "cityCode": "foo",
            "stateCode": "foo",
            "postalCode": "foo",
            "countryCode": "foo",
            "countryName": "foo",
            "latitude": 3.1415,
            "longitude": 3.1415
        },
        "stops": 42,
        "departureTerminal": "foo",
        "arrivalTerminal": "foo",
        "departureTime": "2020-02-14T10:34:56",
        "arrivalTime": "2020-02-15T10:34:56",
        "isCodeShare": true,
        "codeShares": [
            {
                "carrierCode": "SW",
                "number": 42
            }
        ]
    }
""".utf8)
