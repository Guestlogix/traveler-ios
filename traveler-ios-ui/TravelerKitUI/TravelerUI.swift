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

    let paymentProvider: PaymentProvider

    static var shared: TravelerUI? {
        guard _shared != nil else {
            Log("SDK not initialized. Initialize the SDK using `TravelerUI.initialize(paymentProvider:)` in your app delegate.", data: nil, level: .error)
            return nil
        }

        return _shared
    }

    public static func initialize(paymentProvider: PaymentProvider) {
        guard _shared == nil else {
            Log("SDK already initialized!", data: nil, level: .warning)
            return
        }

        _shared = TravelerUI(paymentProvider: paymentProvider)
    }

    init(paymentProvider: PaymentProvider) {
        self.paymentProvider = paymentProvider
    }
}
