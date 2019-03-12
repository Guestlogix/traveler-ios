//
//  StorageOperation.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-09-20.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

class StorageOperation<T>: Operation where T : Encodable {
    let resource: T
    let identifier: String

    private(set) var error: Error?

    init(resource: T, identifier: String) {
        self.resource = resource
        self.identifier = identifier

        super.init()
    }

    override func main() {
        guard !isCancelled else {
            return
        }

        let encoder = JSONEncoder()

        do {
            let data = try encoder.encode(resource)
            UserDefaults.standard.set(data, forKey: identifier)
        } catch {
            self.error = error
        }
    }
}
