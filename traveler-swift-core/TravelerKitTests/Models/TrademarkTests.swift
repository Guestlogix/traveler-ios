//
//  TrademarkTests.swift
//  TravelerKitTests
//
//  Created by Omar Padierna on 2019-07-17.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import XCTest
@testable import TravelerKit

class TrademarkTests: XCTestCase {

    func testTrademarkBadURL() {
        //given
        let jsonData = "{\"iconURL\":\"htp:leURL.bleh\",\"copyright\":\"Display this text\"}".data(using: .utf8)!
        let decoder = JSONDecoder()

        //when
        do {
             let tradeMark = try decoder.decode(Trademark.self, from: jsonData)
        } catch {
            let contextString = String(reflecting: error)
            let contextStringComponents = contextString.components(separatedBy: "debugDescription: ")
            let debugDescription = contextStringComponents[1].components(separatedBy: ",")[0]

            //then
            XCTAssert(debugDescription == "\"Invalid URL for icon\"")
        }

    }

}
