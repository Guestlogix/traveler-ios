//
//  PassengerKit.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-09-12.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public class PassengerKit {
    private let queue = OperationQueue()
    private let session: Session

    private static var _shared: PassengerKit?
    private static var shared: PassengerKit? {
        guard _shared != nil else {
            Log("SDK not initialized. Initialize the SDK using `PassengerKit.initialize(token:)` in you app delegate.", data: nil, level: .error)
            return nil
        }

        return _shared
    }

    public static func initialize(apiKey: String) {
        guard _shared == nil else {
            Log("SDK already initialized!", data: nil, level: .warning)
            return
        }

        _shared = PassengerKit(apiKey: apiKey)
    }

    init(apiKey: String) {
        self.session = Session(apiKey: apiKey)

        let sessionOperation = SessionBeginOperation(session: session)
        OperationQueue.authQueue.addOperation(sessionOperation)
    }

    func identify(_ identifier: String, attributes: [String: Any?]? = nil) {

    }

    func flightSearch(query: FlightQuery, completion: @escaping ([Flight]? , Error?) -> Void) {
        let fetchOperation = AuthenticatedRemoteFetchOperation<[Flight]>(path: .flights(query), session: session)
        let blockOperation = BlockOperation { [unowned fetchOperation] in
            completion(fetchOperation.resource, fetchOperation.error)
        }

        blockOperation.addDependency(fetchOperation)

        queue.addOperation(fetchOperation)
        OperationQueue.main.addOperation(blockOperation)
    }

    public static func fightSearch(query: FlightQuery, delegate: FlightSearchDelegate) {
        shared?.flightSearch(query: query, completion: { [weak delegate] (flights, error) in
            if let flights = flights {
                delegate?.flightSearchDidSucceedWith(flights)
            } else {
                delegate?.flightSearchDidFailWith(error!)
            }
        })
    }

    public static func flightSearch(query: FlightQuery, completion: @escaping ([Flight]? , Error?) -> Void) {
        shared?.flightSearch(query: query, completion: completion)
    }

    public static func clearStoredCredentials() {
        SecItemDelete([
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: tokenKeychainKey
            ] as CFDictionary)
    }
}
