//
//  APIClient.swift
//  TravelerStripePaymentProvider
//
//  Created by Ata Namvari on 2019-11-11.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import Stripe
import TravelerKit

enum APIClientError: Error {
    case badData
}

class APIClient: NSObject, STPCustomerEphemeralKeyProvider {
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        Traveler.fetchEphemeralStripeCustomerKey(forVersion: apiVersion) { (key, error) in
            switch error {
            case .none:
                guard let json = key?.jsonKey as? [AnyHashable : Any] else {
                    Log("Could not read JSON from EphemeralKey", data: key?.jsonKey, level: .error)
                    completion(nil, APIClientError.badData)
                    return
                }

                completion(json, nil)
            case .some(let error):
                completion(nil, error)
            }
        }
    }
}
