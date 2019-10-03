//
//  PaymentError.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-10-01.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// Errors that occur when processing  `Payment`s
public enum PaymentError: Error {
    /// An error with the payment
    case processingError
    /// Confirmation is required (2-Factor), a confirmation key is associated with this case
    case confirmationRequired(String)
    /// The confirmation of payment failed. An implementation specific error is associated with this case
    case confirmationFailed(Error)
}
