//
//  AirportModelTests.swift
//  TravelerKitTests
//
//  Created by Dorothy Fu on 2019-03-15.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import XCTest
@testable import TravelerKit

class AirportModelTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecodingMissingIATAThrows() throws {
        AssertThrowsKeyNotFound("iata", decoding: Airport.self, from: try testAirport.json(deletingKeyPaths: "iata"))
    }

    func testDecodingMissingNameThrows() throws {
        AssertThrowsKeyNotFound("name", decoding: Airport.self, from: try testAirport.json(deletingKeyPaths: "name"))
    }

    func testDecodingMissingCityThrows() throws {
        AssertThrowsKeyNotFound("city", decoding: Airport.self, from: try testAirport.json(deletingKeyPaths: "city"))
    }
}

private let testAirport = Data("""
{
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
}
""".utf8)
