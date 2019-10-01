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
    fileprivate static var paymentConfiguration: STPPaymentConfiguration {
        let config = STPPaymentConfiguration()

        if Traveler.sandboxMode {
            config.publishableKey = "pk_test_yUnRnhSqk2DvuL6Qlx9TNrfx"
        } else {
            config.publishableKey = "pk_live_BbIRatKepYSWQBVL9G9JfR6I"
        }

        return config
    }
}

// Note: Must be presented modally

public class PaymentCollectionViewController: UIViewController, PaymentHandler {
    public weak var delegate: PaymentHandlerDelegate?

    override public func viewDidLoad() {
        super.viewDidLoad()

        let addCardViewController = STPAddCardViewController(configuration: StripePaymentProvider.paymentConfiguration, theme: STPTheme.default())
        addCardViewController.delegate = self

        let navController = UINavigationController(rootViewController: addCardViewController)

        addChild(navController)

        let destView = navController.view!
        destView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        destView.frame = view.bounds
        view.addSubview(destView)
        navController.didMove(toParent: self)
    }
}

extension PaymentCollectionViewController: STPAddCardViewControllerDelegate {
    public func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        dismiss(animated: true, completion: nil)
    }

    private func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreatePaymentMethod paymentMethod: STPPaymentMethod, completion: @escaping STPErrorBlock) {
        let payment = StripePayment(paymentMethod: paymentMethod)
        delegate?.paymentHandler(self, didCollect: payment)
    }
}

struct StripePayment: Payment {
    var localizedDescription: String {
        // TODO: Write descriptions for other method types
        switch paymentMethod.type {
        case .typeCard:
            return "\(paymentMethod.card!.brand) ending in \(String(describing: paymentMethod.card!.last4))"
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
        let jsonPayload: [String: Any] = [
            "paymentMethodId": paymentMethod.stripeId,
        ]

        return try? JSONSerialization.data(withJSONObject: jsonPayload, options: [])
    }
}
