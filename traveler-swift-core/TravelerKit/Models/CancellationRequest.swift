//
//  CancellationRequest.swift
//  TravelerKit
//
//  Created by Ben Ruan on 2019-10-03.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation
/**
 A model representing request to cancel an order
*/
public struct CancellationRequest {
    /// This represents the details about the cancellation such as refund and expiration date and the corresponding `Order`
    public let quote: CancellationQuote
    /// The reason why the users wants to cancel the order
    public let reason: CancellationReason
    /// The textual explanation about why the user wants to cancel the order
    public let explanation: String?

    /**
    Initializes a `CancellationRequest`

    - Parameters:
     - quote: An `CancellationQuote`
     - reason: An `CancellationReason`
     - explanation: An optional `String` explanation for the cancellation reason

    - Returns: `CancellationRequest`
    */
    public init(quote: CancellationQuote, reason: CancellationReason, explanation: String?) {
        self.quote = quote
        self.reason = reason
        self.explanation = explanation
    }

    func validate() -> CancellationError? {
        guard quote.expirationDate > Date() else {
            return CancellationError.expiredQuote
        }

        guard explanation != nil || reason.explanationRequired == false else {
            return CancellationError.explanationRequired
        }

        return nil
    }
}
