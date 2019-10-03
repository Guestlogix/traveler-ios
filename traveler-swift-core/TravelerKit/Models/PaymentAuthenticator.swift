//
//  PaymentAuthenticator.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-10-01.
//  Copyright © 2019 Guestlogix Inc. All rights reserved.
//

import Foundation

/**
 The delegate of a `PaymentAuthenticator` that is notified of the authentication results
 */
public protocol PaymentAuthenticationDelegate: class {
    /// The authentication was successful. You can retry processing the payment agian.
    func paymentAuthenticationDidSucceed()
    /**
        The authentcation failed.

        - Parameters:
        - authenticator: The class that performed the authentication
        - error: The error that failed the authentication process
     */
    func paymentAuthenticationDidFailWith(_ error: Error)
}

/// A class that handles payment authentication (2-Factor) and notifies it's delegate
public protocol PaymentAuthenticator: class {
    associatedtype Controller

    /// The delegate that is notified of the authentication results
    var delegate: PaymentAuthenticationDelegate? { get set }
    /**
     Perform asynchronous authentication

     - Parameters:
     - key: The key `String` that was acquired from the confirmation required error.
     */
    func authenticate(with key: String, controller: Controller)
}
