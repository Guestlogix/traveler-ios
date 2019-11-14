//
//  TravelerUI.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-02-08.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit

public class TravelerUI {
    private static var _shared: TravelerUI?

    let paymentHandlerViewControllerType: (PaymentHandler & UIViewController).Type
    let authenticator: Authenticator
    let paymentManager: PaymentManager.Type

    var preferredCurrency: Currency

    static var shared: TravelerUI? {
        guard _shared != nil else {
            Log("SDK not initialized. Initialize the SDK using `TravelerUI.initialize(paymentProvider:)` in your app delegate.", data: nil, level: .error)
            return nil
        }

        return _shared
    }

    // MARK: Public API

    public static var preferredCurrency: Currency {
        get {
            return shared?.preferredCurrency ?? .USD
        }
        set {
            shared?.preferredCurrency = newValue

            NotificationCenter.default.post(name: .preferredCurrencyDidChange, object: nil)
        }
    }

    // TODO: Encapsulate the arguments into a single one to make it easier to initialize?
    // This might be difficult cause of the generic thing going on here

    public static func initialize<PA : PaymentAuthenticator>(paymentHandler: (PaymentHandler & UIViewController).Type,
                                                             paymentAuthenticator: PA,
                                                             paymentManager: PaymentManager.Type,
                                                             preferredCurrency: Currency = .USD) where PA.Controller == UIViewController {
        guard _shared == nil else {
            Log("SDK already initialized!", data: nil, level: .warning)
            return
        }

        _shared = TravelerUI(paymentHandler: paymentHandler,
                             authenticator: Authenticator(paymentAuthenticator),
                             paymentManager: paymentManager,
                             preferredCurrency: preferredCurrency)
    }

    init(paymentHandler: (PaymentHandler & UIViewController).Type,
         authenticator: Authenticator,
         paymentManager: PaymentManager.Type,
         preferredCurrency: Currency) {
        self.paymentHandlerViewControllerType = paymentHandler
        self.preferredCurrency = preferredCurrency
        self.authenticator = authenticator
        self.paymentManager = paymentManager
    }
}
