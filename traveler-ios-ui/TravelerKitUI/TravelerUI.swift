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
    
    let paymentHandler: PaymentHandler
    let paymentViewController: UIViewController
    
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
    
    public static func initialize(paymentHandler: PaymentHandler, paymentViewController: UIViewController, preferredCurrency: Currency = .USD) {
        guard _shared == nil else {
            Log("SDK already initialized!", data: nil, level: .warning)
            return
        }
        
        _shared = TravelerUI(paymentProvider: paymentHandler, paymentViewController: paymentViewController, preferredCurrency: preferredCurrency)
    }
    
    init(paymentProvider: PaymentHandler, paymentViewController: UIViewController, preferredCurrency: Currency) {
        self.paymentHandler = paymentProvider
        self.preferredCurrency = preferredCurrency
        self.paymentViewController = paymentViewController
    }
}
