//
//  BookingItemTests.swift
//  TravelerKitTests
//
//  Created by Omar Padierna on 2019-10-22.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import XCTest
@testable import TravelerKit

class BookingItemTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCompleteBookingItem() throws {
        //Given
        let data = MockResponses.bookingItem().jsonData()
        
        let decoder = JSONDecoder()

        //When
        let bookingItem = try decoder.decode(BookingItem.self, from: data)
        
        //Then
        XCTAssertTrue(bookingItem.title == "Normalized item")
    }
}
