//
//  KeychainStoreOperation.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-09-25.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

enum KeychainError: Error {
    case notFound
    case unexpectedData
    case unhandledError(OSStatus)
}

class KeychainStoreOperation: Operation {
    let key: String

    private var _value: Data?
    var value: Data? {
        get {
            return _value
        }
        set {
            assert(isExecuting == false && isFinished == false, "Cannot change value once the operation has started or finished.")
            _value = newValue
        }
    }

    private(set) var error: Error?

    init(key: String, value: Data?) {
        self.key = key
        self._value = value

        super.init()
    }

    override func main() {
        guard !isCancelled, let value = _value else {
            return
        }

        let query: CFDictionary = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ] as CFDictionary

        let readStatus = SecItemCopyMatching(query, nil)

        if readStatus == errSecSuccess {
            let updateStatus = SecItemUpdate(query, [
                kSecValueData as String: value
                ] as CFDictionary)

            if updateStatus != errSecSuccess {
                self.error = KeychainError.unhandledError(updateStatus)
                return
            }
        } else {
            let addStatus = SecItemAdd([
                kSecClass as String: kSecClassGenericPassword,
                kSecAttrAccount as String: key,
                kSecValueData as String: value
                ] as CFDictionary, nil)

            if addStatus != errSecSuccess {
                self.error = KeychainError.unhandledError(addStatus)
                return
            }
        }
    }
}
