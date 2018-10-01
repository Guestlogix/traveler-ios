//
//  AuthenticatedRemoteFetchOperation.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-09-25.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

class AuthenticatedRemoteFetchOperation<T>: ConcurrentOperation where T : Decodable {
    let path: AuthPath
    let session: Session

    private(set) var resource: T?
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

        let refetchOperation = RemoteFetchOperation<T>()

        let routeOperation = BlockOperation { [unowned authOperation, unowned refetchOperation] in
            guard let token = authOperation.session.token else {
                refetchOperation.cancel()
                return
            }

            refetchOperation.route = PassengerRoute.authenticated(path, apiKey: session.apiKey, token: token)
        }

        let finishOperation = BlockOperation { [unowned self, unowned refetchOperation, unowned authOperation] in
            self.error = self.error ?? authOperation.error ?? refetchOperation.error
            self.resource =  self.resource ?? refetchOperation.resource
            self.finish()
        }

        let fetchOperation = RemoteFetchOperation<T>()

        let errorOperation = BlockOperation { [unowned fetchOperation, unowned authOperation, unowned refetchOperation, unowned routeOperation] in
            switch fetchOperation.error {
            case .some(NetworkError.forbidden):
                break
            default:
                self.error = fetchOperation.error
                self.resource = fetchOperation.resource

                authOperation.cancel()
                refetchOperation.cancel()
                routeOperation.cancel()
            }
        }

        let tokenOperation = BlockOperation { [unowned fetchOperation, unowned errorOperation] in
            guard let token = session.token else {
                fetchOperation.cancel()
                errorOperation.cancel()
                return
            }

            fetchOperation.route = PassengerRoute.authenticated(path, apiKey: session.apiKey, token: token)
        }


        if let ongoingAuthOperation = OperationQueue.authQueue.operations.first {
            tokenOperation.addDependency(ongoingAuthOperation)
        }

        fetchOperation.addDependency(tokenOperation)
        errorOperation.addDependency(fetchOperation)
        authOperation.addDependency(errorOperation)
        routeOperation.addDependency(authOperation)
        refetchOperation.addDependency(routeOperation)
        finishOperation.addDependency(refetchOperation)

        OperationQueue.authQueue.addOperation(authOperation)

        internalQueue.addOperation(tokenOperation)
        internalQueue.addOperation(fetchOperation)
        internalQueue.addOperation(errorOperation)
        internalQueue.addOperation(refetchOperation)
        internalQueue.addOperation(routeOperation)
        internalQueue.addOperation(finishOperation)

        internalQueue.isSuspended = false
    }
}
