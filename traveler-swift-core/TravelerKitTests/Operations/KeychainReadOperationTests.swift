//
//  KeychainReadOperationTests.swift
//  TravelerKitTests
//
//  Created by Ata Namvari on 2018-09-26.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import XCTest
@testable import TravelerKit

class KeychainReadOperationTests: XCTestCase {

    let key = "test-keychainread-key"
    let value = "test-value"

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.

        SecItemDelete([
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
            ] as CFDictionary)
    }

    func testKeychainReadOperationWithData() {
        SecItemAdd([
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: value.data(using: .utf8)!
            ] as CFDictionary, nil)

        let operation = KeychainReadOperation(key: key)
        operation.start()
        operation.waitUntilFinished()

        XCTAssert(operation.error == nil)

        if let data = operation.data, let string = String(data: data, encoding: .utf8) {
            XCTAssert(string == value)
        } else {
            XCTAssert(false)
        }
    }

    func testKeychainReadOperationWithoutData() {
        let operation = KeychainReadOperation(key: key)
        operation.start()
        operation.waitUntilFinished()

        switch operation.error {
        case .some(KeychainError.notFound):
            XCTAssert(true)
        default:
            XCTAssert(false)
        }
    }
}
