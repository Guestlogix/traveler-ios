//
//  SessionBeginOperationTests.swift
//  PassengerKitTests
//
//  Created by Ata Namvari on 2018-09-28.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import XCTest
@testable import PassengerKit

class SessionBeginOperationTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSessionCreation() {
        let session = Session(apiKey: "XJ7B8mFnPj6O8MT4KuwzF9sg4OtxaR6w7EeytIIT")

        let operation = SessionBeginOperation(session: session)
        operation.start()
        operation.waitUntilFinished()

        XCTAssert(session.token != nil)
    }
}
