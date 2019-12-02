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
        let data = MockResponses.trademarkWithBadUrl().jsonData()

        let decoder = JSONDecoder()

        //when
        do {
             let _ = try decoder.decode(Trademark.self, from: data)
        } catch {
            let contextString = String(reflecting: error)
            let contextStringComponents = contextString.components(separatedBy: "debugDescription: ")
            let debugDescription = contextStringComponents[1].components(separatedBy: ",")[0]

            //then
            XCTAssert(debugDescription == "\"Invalid URL for icon\"")
        }

    }

}
