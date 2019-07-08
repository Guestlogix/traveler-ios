//
//  StripePaymentProvider.swift
//  TravelerStripePaymentProvider
//
//  Created by Ata Namvari on 2019-02-08.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit
import TravelerKitUI
import Stripe

public struct StripePaymentProvider: PaymentProvider  {
    private var paymentConfiguration: STPPaymentConfiguration = {
        let config = STPPaymentConfiguration()
        config.publishableKey = "pk_live_BbIRatKepYSWQBVL9G9JfR6I"
        return config
    }()

    public func paymentCollectorPackage() -> (UIViewController, PaymentHandler) {
        let paymentHandler = StripePaymentHandler()

        let addCardViewController = STPAddCardViewController(configuration: paymentConfiguration, theme: STPTheme.default())
        addCardViewController.delegate = paymentHandler

        return (addCardViewController, paymentHandler)
    }

    public init() {
        
    }
}

class StripePaymentHandler: NSObject, PaymentHandler, STPAddCardViewControllerDelegate {
    weak var delegate: PaymentHandlerDelegate?

    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        addCardViewController.dismiss(animated: true, completion: nil)
    }

    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        delegate?.paymentHandler(self, didCollect: StripePayment(token: token))

        addCardViewController.dismiss(animated: true, completion: nil)
    }
}

struct StripePayment: Payment {
    var localizedDescription: String {
        guard let card = token.card else {
            return "UNKNOWN CARD"
        }

        return "\(STPCard.string(from: card.brand)) ending in \(card.last4)"
    }

    var attributes: [Attribute] {
        guard let card = token.card else {
            return []
        }

        return [
            Attribute(label: "Credit card number", value: card.last4),
            Attribute(label: "Expiry date", value: "\(card.expMonth)/\(card.expYear)")
        ]
    }

    let token: STPToken

    func securePayload() -> Data? {
        let jsonPayload = [
            "token": token.tokenId
        ]

        return try? JSONSerialization.data(withJSONObject: jsonPayload, options: [])
    }
}
