//
//  Receipt.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-02-01.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public struct Receipt {
    public let order: Order
    public let payment: Payment

    init(order: Order, payment: Payment) {
        self.order = order
        self.payment = payment
    }
}
