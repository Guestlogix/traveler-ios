//
//  StripePaymentAuthenticator.swift
//  TravelerStripePaymentProvider
//
//  Created by Ata Namvari on 2019-11-13.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import Stripe
import TravelerKit

public class StripePaymentAuthenticator: NSObject, STPAuthenticationContext, PaymentAuthenticator {
    public typealias Controller = UIViewController

    public weak var delegate: PaymentAuthenticationDelegate?

    var viewController: UIViewController?

    public func authenticationPresentingViewController() -> UIViewController {
        guard let controller = viewController else {
            fatalError("ViewController was never assigned")
        }

        return controller
    }

    public func authenticate(with key: String, controller: UIViewController) {
        self.viewController = controller

        STPPaymentHandler.shared().apiClient = STPAPIClient(configuration: StripePaymentProvider.paymentConfiguration)
        STPPaymentHandler.shared().handleNextAction(forPayment: key, authenticationContext: self, returnURL: nil) {
            [weak delegate]
            (status, intent, error) in

            switch status {
            case .succeeded:
                delegate?.paymentAuthenticationDidSucceed()
            case .failed:
                delegate?.paymentAuthenticationDidFailWith(PaymentError.confirmationFailed(error!))
            case .canceled:
                break
            }
        }
    }
}
