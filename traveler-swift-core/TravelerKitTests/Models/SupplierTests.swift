//
//  SupplierTests.swift
//  TravelerKitTests
//
//  Created by Omar Padierna on 2019-07-17.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import XCTest
@testable import TravelerKit

class SupplierTests: XCTestCase {

    func testCompleteSupplier() {
        //given

        let jsonData = "{\"id\": \"SupplierID\",\"name\": \"Tiqets\",\"trademark\": {\"iconURL\": \"https://myicon.com\",\"copyright\": \"DisplayThisText\"}}".data(using: .utf8)!

        let decoder = JSONDecoder()
        let trademark = Trademark(iconURL: URL(string: "https://myicon.com")! , copyright: "DisplayThisText")

        //when
        let supplier = try! decoder.decode(Supplier.self, from: jsonData)


        //then
        XCTAssert(supplier.id == "SupplierID")
        XCTAssert(supplier.name == "Tiqets")
        XCTAssert(supplier.trademark!.iconURL == trademark.iconURL)
        XCTAssert(supplier.trademark!.copyRight == trademark.copyRight)
    }

    func testIncompleteSupplier() {
        //given
        let jsonData = "{\"id\": \"SupplierID\",\"name\": \"Tiqets\",\"trademark\": null}".data(using: .utf8)!

        let decoder = JSONDecoder()

        //when
        let supplier = try! decoder.decode(Supplier.self, from: jsonData)

        //then
        XCTAssert(supplier.trademark == nil)

    }
}
