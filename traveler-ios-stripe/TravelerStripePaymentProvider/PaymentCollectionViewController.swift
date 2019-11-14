//
//  PaymentCollectionViewController.swift
//  TravelerStripePaymentProvider
//
//  Created by Ata Namvari on 2019-11-13.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import Stripe
import TravelerKit

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

    public func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreatePaymentMethod paymentMethod: STPPaymentMethod, completion: @escaping STPErrorBlock) {
        let payment = StripePayment(paymentMethod: paymentMethod)
        delegate?.paymentHandler(self, didCollect: payment)
        dismiss(animated: true, completion: nil)
    }
}
