//
//  Receipt.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-02-01.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// A reciept that holds the order details as well as the payment details of a particular `Order`.
public struct Receipt {
    /// The `Order` associated with the receipt
    public let order: Order
    /// The `Payment` associated with the receipt
    public let payment: Payment

    init(order: Order, payment: Payment) {
        self.order = order
        self.payment = payment
    }
}
