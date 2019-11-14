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

public struct StripePaymentProvider: PaymentManager {
    static var paymentConfiguration: STPPaymentConfiguration {
        let config = STPPaymentConfiguration()

        if Traveler.sandboxMode {
            config.publishableKey = "pk_test_yUnRnhSqk2DvuL6Qlx9TNrfx"
        } else {
            config.publishableKey = "pk_live_BbIRatKepYSWQBVL9G9JfR6I"
        }

        return config
    }

    // MARK: Public API
    //TODO: Add documentation
    public static func fetchPayments(completion: @escaping ([Payment]?, Error?) -> Void) {
        STPCustomerContext(keyProvider: APIClient()).listPaymentMethodsForCustomer { (methods, error) in
            guard let payments = methods?.map({ StripePayment(paymentMethod: $0) }) else {
                completion(nil, error)
                return
            }

            completion(payments, nil)
        }
    }

    public static func fetchPayments(delegate: PaymentsFetchDelegate) {
        self.fetchPayments { [weak delegate] (payments, error) in
            if let payments = payments {
                delegate?.paymentsFetchDidSucceedWith(payments)
            } else {
                delegate?.paymentsFetchDidFailWith(error!)
            }
        }
    }

    public static func savePayment(_ payment: Payment, completion: @escaping ((Error?) -> Void)) {
        guard let stripePayment = payment as? StripePayment else {
            Log("Unknown Payment type", data: type(of: payment), level: .error)
            return
        }

        STPCustomerContext(keyProvider: APIClient()).attachPaymentMethod(toCustomer: stripePayment.paymentMethod) { (error) in
            if let error = error {
                Log("Error saving payment info", data: error, level: .warning)
            }

            completion(error)
        }
    }

    public static func savePayment(_ payment: Payment, delegate: PaymentSaveDelegate) {
        self.savePayment(payment) { [weak delegate] (error) in
            if let error = error {
                delegate?.savePaymentDidFailWith(error)
            } else {
                delegate?.savePaymentDidSucceed()
            }
        }
    }
}
