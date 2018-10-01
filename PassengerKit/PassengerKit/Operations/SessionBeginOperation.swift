//
//  SessionBeginOperation.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-09-20.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

let tokenKeychainKey = "com.guestlogix.tokenKeychainKey"

class SessionBeginOperation: ConcurrentOperation {
    let session: Session

    private let internalQueue = OperationQueue()

    init(session: Session) {
        self.session = session

        super.init()
    }

    override func execute() {
        let session = self.session

        let restoreOperation = KeychainReadOperation(key: tokenKeychainKey)

        let authOperation = AuthOperation(session: session)

        let tokenOperation = BlockOperation { [unowned restoreOperation, unowned authOperation] in
            guard let data = restoreOperation.data else {
                return
            }

            do {
                session.token = try JSONDecoder().decode(Token.self, from: data)
                authOperation.cancel()
            } catch {
                Log("Error decoding token", data: error, level: .error)
            }
        }

        let finishOperation = BlockOperation { [unowned self] in
            self.finish()
        }

        authOperation.addDependency(tokenOperation)
        tokenOperation.addDependency(restoreOperation)
        finishOperation.addDependency(authOperation)

        internalQueue.addOperation(restoreOperation)
        internalQueue.addOperation(tokenOperation)
        internalQueue.addOperation(authOperation)
        internalQueue.addOperation(finishOperation)
    }
}
