//
//  KeychainReadOperation.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-09-25.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

class KeychainReadOperation: Operation {
    let key: String

    private(set) var data: Data?
    private(set) var error: Error?

    init(key: String) {
        self.key = key

        super.init()
    }

    override func main() {
        guard !isCancelled else {
            return
        }

        let query = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true
        ] as CFDictionary

        var item: CFTypeRef?

        let status = SecItemCopyMatching(query, &item)

        if (status == errSecItemNotFound) {
            self.error = KeychainError.notFound
            return
        } else if (status != errSecSuccess) {
            self.error = KeychainError.unhandledError(status)
            return
        }

        guard let data = item as? Data else {
            self.error = KeychainError.unexpectedData
            return
        }

        self.data = data
    }
}
