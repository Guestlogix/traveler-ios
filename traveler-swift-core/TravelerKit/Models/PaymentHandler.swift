//
//  PaymentHandler.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-02-08.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public protocol PaymentHandlerDelegate: class {
    func paymentHandler(_ handler: PaymentHandler, didCollect payment: Payment)
}

public protocol PaymentHandler: class {
    var delegate: PaymentHandlerDelegate? { get set }
}
