//
//  RemoteRequestOperation.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-06-21.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public protocol RemoteRequestOperationDelegate: class {
    func remoteOperation(_ operation: RemoteRequestOperation, didFailWith error: Error)
    func remoteOperationDidFinish(_ operation: RemoteRequestOperation)

}

public class RemoteRequestOperation: ConcurrentOperation {

    public fileprivate(set) var error: Error?
    public private(set) var jsonResponse: Any?
    private var _route: Route?
    public var route:Route? {
        get {
            return _route
        }
        set {
            assert(isExecuting == false && isFinished == false, "Cannot change `route` once the operation has started or finished")
            _route = newValue
        }
    }
    public weak var delegate: RemoteRequestOperationDelegate?

    private let completion: ((Error?) -> Void)?

    fileprivate let internalQueue = OperationQueue()

    public init(route: Route? = nil, completion: ((Error?) -> Void)? = nil) {
        self._route = route
        self.completion = completion

        super.init()

        internalQueue.isSuspended = true
    }

    public override func execute() {
        let networkOperation = NetworkOperation(route: route)

        let finishOperation = BlockOperation { [unowned self, unowned networkOperation] in
            self.error = networkOperation.error
            self.completion?(self.error)

            if let error = self.error {
                self.delegate?.remoteOperation(self, didFailWith: error)
            } else {
                self.delegate?.remoteOperationDidFinish(self)
            }

            self.finish()
        }

        finishOperation.addDependency(networkOperation)

        internalQueue.addOperation(networkOperation)
        internalQueue.addOperation(finishOperation)

        internalQueue.isSuspended = false
    }
}
