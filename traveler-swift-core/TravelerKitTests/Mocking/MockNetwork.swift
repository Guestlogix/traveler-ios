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
class MockNetwork: URLProtocol {

  /// The key-pairs of URLs this URLProtocol intercepts with their simulated response.
  static var mockResponses: [URL: Result<Data, Error>] = [:]

  override class func canInit(with request: URLRequest) -> Bool {
    guard let url = request.url else { return false }
    return mockResponses.keys.contains(url)
  }

  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    // Overriding this function is required by the superclass.
    return request
  }

  override func startLoading() {
    guard let response = MockNetwork.mockResponses[self.request.url!] else {
      fatalError(
        "No mock response for \(request.url!). This should never happen. Check " +
        "the implementation of `canInit(with request: URLRequest) -> Bool`"
      )
    }

    // Simulate response on a background thread.
    DispatchQueue.global(qos: .default).async {
      switch response {
      case let .success(data):
        // Simulate received data.
        self.client?.urlProtocol(self, didLoad: data)

        // Finish loading (required).
        self.client?.urlProtocolDidFinishLoading(self)

      case let .failure(error):
        // Simulate error.
        self.client?.urlProtocol(self, didFailWithError: error)
      }
    }
  }

  override func stopLoading() {
    // Required by the superclass.
  }
}
