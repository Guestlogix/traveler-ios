//
//  StripePayment.swift
//  TravelerStripePaymentProvider
//
//  Created by Ata Namvari on 2019-11-13.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import Stripe
import TravelerKit

struct StripePayment: Payment {
    var localizedDescription: String {
        // TODO: Write descriptions for other method types
        switch paymentMethod.type {
        case .typeCard:
            return "\(paymentMethod.card!.brand.name) ending in \(String(describing: paymentMethod.card.unsafelyUnwrapped.last4!))"
        case .typeCardPresent:
            return "CardPresent"
        case .typeFPX:
            return "FPX"
        case .typeiDEAL:
            return "iDEAL"
        case .typeUnknown:
            return "Unknown payment type"
        }
    }

    var attributes: [Attribute] {
        // TODO: Return attributes for other method types
        guard let card = paymentMethod.card else {
            return []
        }

        return [
            Attribute(label: "Credit card number", value: card.last4 ?? "****"),
            Attribute(label: "Expiry date", value: "\(card.expMonth)/\(card.expYear)")
        ]
    }

    let paymentMethod: STPPaymentMethod

    func securePayload() -> Data? {
        let jsonPayload: [String: Any?] = [
            "paymentMethodId": paymentMethod.stripeId,
        ]

        return try? JSONSerialization.data(withJSONObject: jsonPayload, options: [])
    }
}
