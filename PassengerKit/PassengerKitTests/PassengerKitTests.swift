//
//  PassengerKitTests.swift
//  PassengerKitTests
//
//  Created by Ata Namvari on 2018-09-05.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import XCTest
@testable import PassengerKit

class PassengerKitTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testFlightSearch() {
        let passengerKit = PassengerKit(apiKey: "XJ7B8mFnPj6O8MT4KuwzF9sg4OtxaR6w7EeytIIT")

        let query = FlightQuery(number: "SA1", date: DateFormatter.yearMonthDay.date(from: "2018/02/27")!)
        let exp = expectation(description: "Should get a response")

        passengerKit.flightSearch(query: query) { (flights, error) in
            exp.fulfill()
        }

        wait(for: [exp], timeout: 2)
    }
    
}
