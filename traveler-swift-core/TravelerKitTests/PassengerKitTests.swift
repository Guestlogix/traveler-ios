//
//  TravelerKitTests.swift
//  TravelerKitTests
//
//  Created by Ata Namvari on 2018-09-05.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import XCTest
@testable import TravelerKit

class TravelerKitTests: XCTestCase {
    var traveler: Traveler!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        traveler = Traveler(apiKey: "TokenyToken", device: MockDevice(), sandboxMode: true)
        let mockAPI = MockAPI()

        mockAPI.loadURLs(for: .authenticate(key: "TokenyToken"))
        mockAPI.loadURLs(for: .flights(number: "AC1981", date: DateFormatter.yearMonthDay.date(from: "2019/12/27")!))
        mockAPI.loadURLs(for: .catalog(flights: nil))
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFlightSearch() {
        let query = FlightQuery(number: "AC1981", date: DateFormatter.yearMonthDay.date(from: "2019/12/27")!)
        let exp = expectation(description: "Should get a response")

        traveler.flightSearch(query: query) { (flights, error) in
            guard let flight = flights?[0] else {
                XCTFail()
                return
            }

            XCTAssertEqual(flight.arrivalAirport.code, "YYZ")
            exp.fulfill()
        }

        wait(for: [exp], timeout: 2)
    }

    func testCatalog() {
        let query = CatalogQuery()

        let exp = expectation(description: "Should get a response")

        traveler.fetchCatalog(query: query) { (catalog, error) in
            XCTAssertNotNil(catalog)
            exp.fulfill()
        }

        wait(for: [exp], timeout: 2)
    }
}
