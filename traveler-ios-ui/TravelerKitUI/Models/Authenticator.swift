//
//  Authenticator.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-10-01.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit

class Authenticator: PaymentAuthenticationDelegate {
    weak var delegate: PaymentAuthenticationDelegate?

    var authenticate: (_ key: String, _ controller: UIViewController) -> Void

    init<PA : PaymentAuthenticator>(_ authenticator: PA) where PA.Controller == UIViewController {
        self.authenticate = { (key, controller) in
            authenticator.authenticate(with: key, controller: controller)
        }

        authenticator.delegate = self
    }

    func paymentAuthenticationDidSucceed() {
        delegate?.paymentAuthenticationDidSucceed()
    }

    func paymentAuthenticationDidFailWith(_ error: Error) {
        delegate?.paymentAuthenticationDidFailWith(error)
    }
}
