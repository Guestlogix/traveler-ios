//
//  STPCardBrand+Traveler.swift
//  TravelerStripePaymentProvider
//
//  Created by Ata Namvari on 2019-11-13.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import Stripe

extension STPCardBrand {
    var name: String {
        switch self {
        case .visa:
            return "Visa"
        case .amex:
            return "American Express"
        case .dinersClub:
            return "Diners Club"
        default:
            return "Credit card"
        }
    }
}
