//
//  Payment.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-02-08.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// A protocol that defines what are the values needed to properly process payment.
public protocol Payment {
    /**
     An `Array<Attribute>` that hold insensitive information about the payment.
     In case of credit cards this would include things like 'Card Type', 'Last 4 Digits', etc.
     */
    var attributes: [Attribute] { get }

    /// The secure (encrypted) payload that is safe to transmit over the internet for processing.
    func securePayload() -> Data?
}
