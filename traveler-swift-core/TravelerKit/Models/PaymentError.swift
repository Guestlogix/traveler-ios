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

extension PaymentError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .processingError:
            return NSLocalizedString("processingPaymentError", value: "Sorry something went wrong while processing your payment, please try again with a different credit card or try again later", comment: "Payment Error")
        case .confirmationRequired(_):
            return NSLocalizedString("paymentConfirmationRequiredError", value: "Your payment requires confirmation", comment: "Payment Confirmation Required")
        case .confirmationFailed(_):
            return NSLocalizedString("paymentConfirmationFailedError", value: "Confirmation failed please try again or try with a different credit card", comment: "Payment Confirmation Failed")
        }

    }
}
