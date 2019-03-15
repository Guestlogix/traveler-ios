//
//  FlightQueryModelTests.swift
//  TravelerKitTests
//
//  Created by Dorothy Fu on 2019-03-15.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import XCTest
@testable import TravelerKit

class FlightQueryModelTests: XCTestCase {
    var currDate: Date!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        currDate = formatter.date(from: "20190205")
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNumberFullInitialized() {
        let sut = FlightQuery(number: "AC0120", date: currDate!)
        XCTAssertEqual(sut.number, "AC0120")
    }

    func testNumberShortInitialized() {
        let sut = FlightQuery(number: "AC1", date: currDate!)
        XCTAssertEqual(sut.number, "AC1")
    }

    func testDateInitialized() {
        let sut = FlightQuery(number: "AC0120", date: currDate!)
        XCTAssertEqual(sut.date, currDate)
    }

}
