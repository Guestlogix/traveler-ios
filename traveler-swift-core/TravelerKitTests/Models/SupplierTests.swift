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

    func testCompleteSupplier() throws {
        //given
        let data = MockResponses.supplier().jsonData()

        let decoder = JSONDecoder()
        let trademark = Trademark(iconURL: URL(string: "https://myicon.com")! , copyRight: "Simple ricks")

        //when
        let supplier = try decoder.decode(Supplier.self, from: data)

        //then
        XCTAssert(supplier.name == "Tiqets")
        XCTAssert(supplier.trademark!.iconUrl == trademark.iconUrl)
        XCTAssert(supplier.trademark!.copyright == trademark.copyright)
    }

    func testIncompleteSupplier() {
        //given
        let data = MockResponses.supplierNoTradeMark().jsonData()

        let decoder = JSONDecoder()

        //when
        let supplier = try! decoder.decode(Supplier.self, from: data)

        //then
        XCTAssert(supplier.trademark == nil)

    }
}
