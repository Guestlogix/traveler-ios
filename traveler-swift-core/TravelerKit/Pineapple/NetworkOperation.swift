//
//  NetworkOperation.swift
//  Cardinal
//
//  Created by Ata Namvari on 2017-05-07.
//  Copyright © 2017 capco. All rights reserved.
//

import Foundation

public protocol NetworkOperationDelegate: class {
    func networkOperation(_ operation: NetworkOperation, didFinishWithData data: Data?, urlResponse: HTTPURLResponse?)
    func networkOperation(_ operation: NetworkOperation, didFailWith error: Error)
}

open class NetworkOperation: ConcurrentOperation {

    private var _route: Route?
    public var route: Route? {
        get {
            return _route
        }
        set {
            assert(isExecuting == false && isFinished == false, "Cannot change route once the operation has started or finished.")
            _route = newValue
        }
    }

    public internal(set) var data: Data?
    public internal(set) var response: HTTPURLResponse?
    public internal(set) var error: Error?
    public var dataCompletionBlock:((Data) -> Void)?
    public weak var delegate: NetworkOperationDelegate?

    required public init(route: Route? = nil) {
        self._route = route
        super.init()
    }

    convenience public init(route: Route, dataCompletionBlock: ((Data?) -> Void)?) {
        self.init(route: route)
        self.dataCompletionBlock = dataCompletionBlock
    }

    override open func execute() {
        guard let route = route else {
            Log("No route", data: nil, level: .error)
            self.finish()
            return
        }

        let urlRequest = route.urlRequest

        Log("URLRequest: ", data: "\(urlRequest.httpMethod ?? "") \(urlRequest.url?.absoluteString ?? "")", level: .debug)

        urlRequest.httpBody.flatMap {
            Log("Payload", data: String(data: $0, encoding: .utf8), level: .debug)
        }

        let urlSessionTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) -> Void in
            defer {
                self.finish()
            }

            if self.isCancelled {
                return
            }

            let response = response as? HTTPURLResponse

            self.error = error ?? response.flatMap({ NetworkError(data: data, response: $0) })
            self.error = self.error.flatMap({ route.transform(error: $0) })
            self.data = data
            self.response = response

            data.flatMap { self.dataCompletionBlock?($0) }

            switch error {
            case let error as NetworkError:
                Log(error.localizedDescription, data: error.data, level: error.logLevel)
                self.delegate?.networkOperation(self, didFailWith: error)
            case .some(let error):
                Log("Error: \(error.localizedDescription)", data: data.flatMap({ String(data: $0, encoding: .utf8) }), level: .error)
                self.delegate?.networkOperation(self, didFailWith: error)
            // TODO: 4 levels and 5 levels should be an error
            case .none:
                Log("Successful", data: "\(response?.statusCode ?? 0) - \(response?.url?.absoluteString ?? "[URL]")", level: .debug)
                Log("Body", data: data.flatMap({ String(data: $0, encoding: .utf8) }), level: .trace)
                self.delegate?.networkOperation(self, didFinishWithData: data, urlResponse: response)
            }
        })

        urlSessionTask.resume()
    }
}
