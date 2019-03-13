//
//  SessionRestoreOperation.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-09-20.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

enum StorageError: Error {
    case noResource
}

class RestoreOperation<T>: ConcurrentOperation where T : Decodable {
    let identifier: String

    private(set) var resource: T?
    private(set) var error: Error?

    private let internalQueue = OperationQueue()

    init(identifier: String) {
        self.identifier = identifier

        super.init()
    }

    override func execute() {
        guard let data = UserDefaults.standard.data(forKey: identifier) else {
            self.error = StorageError.noResource
            self.finish()
            return
        }

        let mappingOperation = MappingOperation<T>()
        mappingOperation.data = data

        let finishOperation = BlockOperation { [unowned self, unowned mappingOperation] in
            self.error = mappingOperation.error
            self.resource = mappingOperation.mappedResource
            self.finish()
        }

        finishOperation.addDependency(mappingOperation)

        internalQueue.addOperation(mappingOperation)
        internalQueue.addOperation(finishOperation)
    }
}
