//
//  Receipt.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2019-02-01.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public struct Receipt {
    public let product: Product
    public let date: Date?
    public let confirmationNumber: String
    public let customerContact: CustomerContact

    init(bookingOrder: BookingOrder, confirmationNumber: String, customerContact: CustomerContact) {
        self.product = bookingOrder.product
        self.date = bookingOrder.date
        self.confirmationNumber = confirmationNumber
        self.customerContact = customerContact
    }
}
