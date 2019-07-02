//
//  EmailOrderConfirmationDelegate.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-06-21.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// Notified of sending order confirmation by email
public protocol EmailOrderConfirmationDelegate: class {
    /**
     Called when the order confirmation was sent successfully
     - Parameters:
     */
    func emailDidSucceed()
    /**
     Called when there was an error sending the order confirmation

     - Parameters:
     - error: The `Error` representing the reason for failure.
     */
    func emailDidFailWith(_ error: Error)
}
