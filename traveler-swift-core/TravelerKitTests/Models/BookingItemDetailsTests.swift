//
//  BookingItemDetailsTests.swift
//  TravelerKitTests
//
//  Created by Omar Padierna on 2019-10-23.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import XCTest
@testable import TravelerKit

class BookingItemDetailsTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBookingItemDetails() throws {
        //Given
        let data = MockResponses.bookingItemDetails().jsonData()

        let decoder = JSONDecoder()

        //When
        let bookingItemDetails = try decoder.decode(BookingItemDetails.self, from: data)

        //Then
        XCTAssertTrue(bookingItemDetails.title == "The Anatomy Park")
    }

}
