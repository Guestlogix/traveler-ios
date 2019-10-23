//
//  AnyItemTests.swift
//  TravelerKitTests
//
//  Created by Omar Padierna on 2019-10-23.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import XCTest
@testable import TravelerKit

class AnyItemTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testBookingItem() throws {
        //Given
        let data = DataResponses.bookingItemData()
        let decoder = JSONDecoder()
        //When

        let anyItem = try decoder.decode(AnyItem.self, from: data)

        //Then
        XCTAssertNil(anyItem.parkingItem)
        XCTAssertNotNil(anyItem.bookingItem)
    }

}
