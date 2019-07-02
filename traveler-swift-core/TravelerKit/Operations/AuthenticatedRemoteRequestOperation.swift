//
//  AuthenticatedRemoteRequestOperation.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-06-21.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

class AuthenticatedRemoteRequestOperation: ConcurrentOperation {
    var path: AuthPath
    let session: Session

    private(set) var error: Error?

    private let internalQueue = OperationQueue()

    init(path: AuthPath, session: Session) {
        self.path = path
        self.session = session

        super.init()

        internalQueue.isSuspended = true
    }

    override func execute() {
        let path = self.path
        let session = self.session

        let authOperation = AuthOperation(session: session)

        let rerequestOperation = RemoteRequestOperation()

        let routeOperation = BlockOperation { [unowned authOperation, unowned rerequestOperation] in
            guard let token = authOperation.session.token else {
                rerequestOperation.cancel()
                return
            }

            rerequestOperation.route = PassengerRoute.authenticated(path, apiKey: session.apiKey, token: token)
        }

        let finishOperation = BlockOperation { [unowned self, unowned rerequestOperation, unowned authOperation] in
            self.error = self.error ?? authOperation.error ?? rerequestOperation.error
            self.finish()
        }

        let requestOperation = RemoteRequestOperation()

        let errorOperation = BlockOperation { [unowned requestOperation, unowned authOperation, unowned rerequestOperation, unowned routeOperation] in
            switch requestOperation.error {
            case .some(NetworkError.unauthorized):
                break
            default:
                self.error = requestOperation.error

                authOperation.cancel()
                rerequestOperation.cancel()
                routeOperation.cancel()
            }
        }

        let tokenOperation = BlockOperation { [unowned requestOperation, unowned errorOperation] in
            guard let token = session.token else {
                requestOperation.cancel()
                errorOperation.cancel()
                return
            }

            requestOperation.route = PassengerRoute.authenticated(path, apiKey: session.apiKey, token: token)
        }

        if let ongoingAuthOperation = OperationQueue.authQueue.operations.first {
            tokenOperation.addDependency(ongoingAuthOperation)
        }

        requestOperation.addDependency(tokenOperation)
        errorOperation.addDependency(requestOperation)
        authOperation.addDependency(errorOperation)
        routeOperation.addDependency(authOperation)
        rerequestOperation.addDependency(routeOperation)
        finishOperation.addDependency(rerequestOperation)

        OperationQueue.authQueue.addOperation(authOperation)

        internalQueue.addOperation(tokenOperation)
        internalQueue.addOperation(requestOperation)
        internalQueue.addOperation(errorOperation)
        internalQueue.addOperation(rerequestOperation)
        internalQueue.addOperation(routeOperation)
        internalQueue.addOperation(finishOperation)

        internalQueue.isSuspended = false
    }
}
