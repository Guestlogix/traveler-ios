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

protocol StripePaymentProviderDelegate: class {
    func stripePaymentHandlerAddCardClose(_ controller: STPAddCardViewController)
}

public struct StripePaymentProvider: PaymentProvider  {
    private var paymentConfiguration: STPPaymentConfiguration = {
        let config = STPPaymentConfiguration()
        config.publishableKey = "pk_test_yUnRnhSqk2DvuL6Qlx9TNrfx"
        return config
    }()

    public func paymentCollectorPackage() -> (UIViewController, PaymentHandler) {
        let paymentHandler = StripePaymentHandler()

        let addCardViewController = STPAddCardViewController(configuration: paymentConfiguration, theme: STPTheme.default())
        addCardViewController.delegate = paymentHandler

        return (addCardViewController, paymentHandler)
    }

    public init() {
        weak var addCardDelegate: StripePaymentProviderDelegate?
    }
}

class StripePaymentHandler: NSObject, PaymentHandler, STPAddCardViewControllerDelegate {
    weak var delegate: PaymentHandlerDelegate?

    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        addCardViewController.dismiss(animated: true, completion: { StripePaymentProviderDelegate(addCardViewController) })
    }

    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        delegate?.paymentHandler(self, didCollect: StripePayment(token: token))

        addCardViewController.dismiss(animated: true, completion: { StripePaymentProviderDelegate(addCardViewController) })
    }
}

struct StripePayment: Payment {
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
