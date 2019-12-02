//
//  MockNetwork.swift
//  TravelerKitTests
//
//  Created by Omar Padierna on 2019-10-25.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// The URLProtocol subclass allowing to intercept the network communication
/// and provide custom mock responses for the given URLs.
open class MockNetwork: URLProtocol {
    override open class func canInit(with request: URLRequest) -> Bool {
        guard let _ = MockableEndpoints(url: request.url), request.httpMethod == "GET" else {
            return false
        }
        
        return true
    }

    override open class func canonicalRequest(for request: URLRequest) -> URLRequest {
        // Overriding this function is required by the superclass.
        return request
    }

    override open func startLoading() {
        guard let endpoint = MockableEndpoints(url: self.request.url) else {
            fatalError(
                "Endpoint for \(self.request.url!.path) does not exist. This should never happen."
            )
        }

        // Simulate response on a background thread.
        DispatchQueue.global(qos: .default).async {
            // Simulate received data.
            self.client?.urlProtocol(self, didLoad: endpoint.data)

            // Finish loading (required).
            self.client?.urlProtocolDidFinishLoading(self)
        }
    }

    override open func stopLoading() {
        // Required by the superclass.
    }
}

extension MockNetwork {
    public static func register() {
        URLProtocol.registerClass(MockNetwork.self)
    }
}
