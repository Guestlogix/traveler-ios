//
//  KeychainStoreOperationTests.swift
//  TravelerKitTests
//
//  Created by Ata Namvari on 2018-09-26.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import XCTest
@testable import TravelerKit

class KeychainStoreOperationTests: XCTestCase {

    let key = "test-key"
    let value = "test-value".data(using: .utf8)!

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

    func testKeychainOperationAddsData() {
        let storeOperation = KeychainStoreOperation(key: key, value: value)
        storeOperation.start()
        storeOperation.waitUntilFinished()

        var item: CFTypeRef?

        let status = SecItemCopyMatching([
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecReturnData as String: true
                ] as CFDictionary, &item)

        XCTAssert(status == errSecSuccess, "Could not read from keychain: \(status)")

        if let data = item as? Data {
            let string = String(data: data, encoding: .utf8)
            XCTAssert(string == "test-value")
        } else {
            XCTAssert(false)
        }
    }

    func testKeychainOperationUpdatesData() {
        let key = "test-key"
        let value = "test-value".data(using: .utf8)!

        SecItemAdd([
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: "prev-value"
            ] as CFDictionary, nil)

        let storeOperation = KeychainStoreOperation(key: key, value: value)
        storeOperation.start()
        storeOperation.waitUntilFinished()

        var item: CFTypeRef?

        let status = SecItemCopyMatching([
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true
            ] as CFDictionary, &item)

        XCTAssert(status == errSecSuccess, "Could not read from keychain: \(status)")

        if let data = item as? Data {
            let string = String(data: data, encoding: .utf8)
            XCTAssert(string == "test-value")
        } else {
            XCTAssert(false)
        }
    }
}
