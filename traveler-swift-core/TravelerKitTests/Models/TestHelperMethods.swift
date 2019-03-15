//
//  TestHelperMethods.swift
//  TravelerKitTests
//
//  Created by Dorothy Fu on 2019-03-15.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import XCTest

extension XCTestCase {
    func AssertThrowsKeyNotFound<T: Decodable>(_ expectedKey: String, decoding: T.Type, from data: Data, file: StaticString = #file, line: UInt = #line) {
        XCTAssertThrowsError(try JSONDecoder().decode(decoding, from: data), file: file, line: line) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual(expectedKey, key.stringValue, "Expected missing key '\(key.stringValue)' to equal '\(expectedKey)'.", file: file, line: line)
            } else {
                XCTFail("Expected '.keyNotFound(\(expectedKey))' but got \(error)", file: file, line: line)
            }
        }
    }
}

extension Data {
    func json(deletingKeyPaths keyPaths: String...) throws -> Data {
        let decoded = try JSONSerialization.jsonObject(with: self, options: .mutableContainers) as AnyObject

        for keyPath in keyPaths {
            decoded.setValue(nil, forKeyPath: keyPath)
        }

        return try JSONSerialization.data(withJSONObject: decoded)
    }
}
