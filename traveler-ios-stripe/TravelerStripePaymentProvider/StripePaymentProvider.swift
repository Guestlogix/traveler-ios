//
//  StripePaymentProvider.swift
//  TravelerStripePaymentProvider
//
//  Created by Ata Namvari on 2019-02-08.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit
import Stripe

public struct StripePaymentProvider {

    private let sandBoxModeEnabled: Bool

    private var paymentConfiguration: STPPaymentConfiguration {
        let config = STPPaymentConfiguration()

        if self.sandBoxModeEnabled {
            config.publishableKey = "pk_test_yUnRnhSqk2DvuL6Qlx9TNrfx"
        } else {
            config.publishableKey = "pk_live_BbIRatKepYSWQBVL9G9JfR6I"
        }
        return config
    }

    public func paymentCollectorPackage() -> (UIViewController, PaymentHandler) {
        let paymentHandler = StripePaymentHandler(sandBoxMode: self.sandBoxModeEnabled)

        let addCardViewController = STPAddCardViewController(configuration: paymentConfiguration, theme: STPTheme.default())
        addCardViewController.delegate = paymentHandler

        return (addCardViewController, paymentHandler)
    }

    public init(sandBoxModeEnabled: Bool = false) {
        self.sandBoxModeEnabled = sandBoxModeEnabled
    }
}

class StripePaymentHandler: NSObject, PaymentHandler, STPAddCardViewControllerDelegate {
    weak var delegate: PaymentHandlerDelegate?

    private var sandBoxMode: Bool

    init(sandBoxMode: Bool) {
        self.sandBoxMode = sandBoxMode
    }

    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        addCardViewController.dismiss(animated: true, completion: nil)
    }

    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        delegate?.paymentHandler(self, didCollect: StripePayment(token: token, sandBoxMode: self.sandBoxMode))

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
    let sandBoxMode: Bool

    func securePayload() -> Data? {
        let jsonPayload: [String: Any] = [
            "token": token.tokenId,
            "sandBox": sandBoxMode
        ]

        return try? JSONSerialization.data(withJSONObject: jsonPayload, options: [])
    }
}
