//
//  PaymentProvider.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2019-01-30.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public protocol PaymentProvider {
    func paymentCollectorPackage() -> (UIViewController, PaymentHandler)
}

public protocol PaymentHandlerDelegate: class {
    func paymentHandler(_ handler: PaymentHandler, didCollect payment: Payment)
}

public protocol PaymentHandler: class {
    var delegate: PaymentHandlerDelegate? { get set }
}

public protocol Payment {
    var attributes: [Attribute] { get }

    func securePayload() -> Data?
}
