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

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFlightSearch() {
        let travelerKit = Traveler(apiKey: "XJ7B8mFnPj6O8MT4KuwzF9sg4OtxaR6w7EeytIIT", device: UIDevice.current as! Device)

        let query = FlightQuery(number: "SA1", date: DateFormatter.yearMonthDaySlash.date(from: "2018/02/27")!)
        let exp = expectation(description: "Should get a response")

        travelerKit.flightSearch(query: query) { (flights, error) in
            exp.fulfill()
        }

        wait(for: [exp], timeout: 2)
    }
    
}
