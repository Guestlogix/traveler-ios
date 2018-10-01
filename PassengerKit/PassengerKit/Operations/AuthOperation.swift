//
//  AuthOperation.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-09-14.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

class AuthOperation: ConcurrentOperation {
    let session: Session

    private(set) var error: Error?

    private let internalQueue = OperationQueue()

    init(session: Session) {
        self.session = session

        super.init()
    }

    override func execute() {
        let apiKey = session.apiKey

        let tokenOperation = RemoteFetchOperation<Token>(route: PassengerRoute.unauthenticated(.authenticate(apiKey)))

        let keychainStoreOperation = KeychainStoreOperation(key: tokenKeychainKey, value: nil)

        let dataOperation = BlockOperation { [unowned tokenOperation, unowned keychainStoreOperation, unowned self] in
            do {
                keychainStoreOperation.value = try tokenOperation.resource.flatMap({ try JSONEncoder().encode($0) })
            } catch {
                Log("Error storing in keychain", data: error, level: .warning)
                self.error = error
                keychainStoreOperation.cancel()
            }
        }

        let finishOperation = BlockOperation { [unowned self, unowned tokenOperation, unowned keychainStoreOperation] in
            defer {
                self.finish()
            }

            guard let token = tokenOperation.resource else {
                self.error = tokenOperation.error
                return
            }

            self.error = self.error ?? keychainStoreOperation.error
            self.session.token = token
        }

        dataOperation.addDependency(tokenOperation)
        keychainStoreOperation.addDependency(dataOperation)
        finishOperation.addDependency(keychainStoreOperation)

        internalQueue.addOperation(tokenOperation)
        internalQueue.addOperation(dataOperation)
        internalQueue.addOperation(keychainStoreOperation)
        internalQueue.addOperation(finishOperation)
    }
}
