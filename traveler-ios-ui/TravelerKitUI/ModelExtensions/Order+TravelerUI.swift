//
//  Order+TravelerUI.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-06-20.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit

extension Order {
    var isCancelled: Bool {
        switch self.status {
        case .cancelled:
            return true
        default:
            return false
        }
    }

    var canEmailOrderConfirmation: Bool {
        switch self.status {
        case .confirmed, .underReview:
            return true
        case .declined, .pending, .cancelled, .unknown:
            return false
        }
    }

    var paymentDescription: String? {
        switch self.status {
        case .confirmed(let payment):
            return payment.paymentInfo
        case.cancelled(let payment):
            return payment.paymentInfo
        case .underReview(let payment):
            return payment.paymentInfo
        case .declined(let payment):
            return payment.paymentInfo
        default:
            return nil
        }
    }
}
