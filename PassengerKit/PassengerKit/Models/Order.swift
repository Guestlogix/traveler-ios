//
//  Order.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2019-01-25.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public protocol Order {
    var id: String { get }
    var total: Price { get }
}

struct InternalOrder: Decodable, Order {
    let id: String
    let total: Price
    let customerContact: CustomerContact

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case total = "amount"
        case customerContact = "customer"
    }
}

public struct BookingOrder: Order {
    public let id: String
    public let total: Price
    public let product: Product
    public let passes: [Pass]
    public let date: Date
    public let time: Time?

    public var bookingDateDescription: String? {
        if let time = time {
            return "\(DateFormatter.longFormatter.string(from: date)) \(time.formattedValue)"
        } else {
            return DateFormatter.longFormatter.string(from: date)
        }
    }

    init(internalOrder: InternalOrder, bookingContext: BookingContext, bookingForm: BookingForm) throws {
        guard let date = bookingContext.selectedDate else {
            throw BookingError.noDate
        }

        if bookingContext.requiresTime && bookingContext.selectedTime == nil {
            throw BookingError.noTime
        }

        self.id = internalOrder.id
        self.total = internalOrder.total
        self.product = bookingContext.product
        self.passes = bookingForm.passes
        self.date = date
        self.time = bookingContext.selectedTime
    }
}
