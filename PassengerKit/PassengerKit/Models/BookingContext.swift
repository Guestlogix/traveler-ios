//
//  BookingContext.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-12-04.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public protocol BookingContextObserving: class {
    func bookingContextDidUpdate(_ context: BookingContext)
}

public class BookingContext {
    public var selectedDate: Date? {
        didSet {
            notifyObservers()
        }
    }

    public var selectedTime: Time? {
        didSet {
            notifyObservers()
        }
    }

    public var isReady = true {
        didSet {
            notifyObservers()
        }
    }

    public var requiresTime: Bool {
        return availability?.times.count ?? 0 > 0
    }

    public var hasAvailability: Bool {
        return availability?.isAvailable ?? false
    }

    public var availableTimes: [Time]? {
        return availability?.times
    }

    internal var availability: Availability?

    let product: Product

    public init(product: Product) {
        self.product = product
    }

    private var observers = [BookingContextObserving]()

    public func addObserver(_ observer: BookingContextObserving) {
        observers.append(observer)
    }

    public func removeObserver(_ observer: BookingContextObserving) {
        if let index = observers.firstIndex(where: { $0 === observer }) {
            observers.remove(at: index)
        }
    }

    private func notifyObservers() {
        for observer in observers {
            observer.bookingContextDidUpdate(self)
        }
    }
}
