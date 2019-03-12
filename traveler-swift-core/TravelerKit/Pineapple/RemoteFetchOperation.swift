//
//  RequestOperation.swift
//  Cardinal
//
//  Created by Ata Namvari on 2017-05-08.
//  Copyright © 2017 capco. All rights reserved.
//

import Foundation

public protocol RemoteFetchOperationDelegate: class {
    func remoteFetchOperation<T : Decodable>(_ operation: RemoteFetchOperation<T>, didFailWith error: Error)
    func remoteFetchOperation<T : Decodable>(_ operation: RemoteFetchOperation<T>, didFinishWith resource: T)
}

public class RemoteFetchOperation<T>: ConcurrentOperation where T : Decodable {

    public fileprivate(set) var error: Error?
    public private(set) var resource: T?
    public private(set) var jsonResponse: Any?
    private var _route: Route?
    public var route: Route? {
        get {
            return _route
        }
        set {
            assert(isExecuting == false && isFinished == false, "Cannot change `route` once the operation has started or finished.")
            _route = newValue
        }
    }
    public weak var delegate: RemoteFetchOperationDelegate?
    
    private let completion: ((T?, Error?) -> Void)?

    fileprivate let internalQueue = OperationQueue()

    public init(route: Route? = nil, completion: ((T?, Error?) -> Void)? = nil) {
        self._route = route
        self.completion = completion

        super.init()

        internalQueue.isSuspended = true
    }

    public override func execute() {
        let mappingOperation = MappingOperation<T>()
        let networkOperation = NetworkOperation(route: route)

        networkOperation.delegate = mappingOperation

        let finishOperation = BlockOperation { [unowned self, unowned mappingOperation, unowned networkOperation] in
            self.error = networkOperation.error ?? mappingOperation.error
            self.resource = mappingOperation.mappedResource
            self.completion?(self.resource, self.error)
            
            if let error = self.error {
                self.delegate?.remoteFetchOperation(self, didFailWith: error)
            } else if let resource = self.resource {
                self.delegate?.remoteFetchOperation(self, didFinishWith: resource)
            }
            
            self.finish()
        }

        mappingOperation.addDependency(networkOperation)

        finishOperation.addDependency(networkOperation)
        finishOperation.addDependency(mappingOperation)

        internalQueue.addOperation(networkOperation)
        internalQueue.addOperation(mappingOperation)
        internalQueue.addOperation(finishOperation)

        internalQueue.isSuspended = false
    }
}

extension MappingOperation: NetworkOperationDelegate {
    public func networkOperation(_ operation: NetworkOperation, didFailWith error: Error) {
        cancel()
    }

    public func networkOperation(_ operation: NetworkOperation, didFinishWithData data: Data?, urlResponse: HTTPURLResponse?) {
        self.data = data
    }
}
