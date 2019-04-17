//
//  PaymentHandler.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-02-08.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/**
 The delegate of a `PaymentHandler` that is notified when the `Payment` is collected.
 */
public protocol PaymentHandlerDelegate: class {
    /**
     Called when the handler has successfully collected payment.

     - Parameters:
        - handler: The `PaymentHandler` class that collected the `Payment`.
        - payment: The `Payment` that it collected.
     */
    func paymentHandler(_ handler: PaymentHandler, didCollect payment: Payment)

    func addCardDidClose()
}

/// A class that handles `Payment` and notifies its delegate.
public protocol PaymentHandler: class {
    /// The delegate that is notified of successful payment collection
    var delegate: PaymentHandlerDelegate? { get set }
}
