//
//  AvailabilityCheckDelegate.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-11-23.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public protocol AvailabilityCheckDelegate: class {
    func availabilityCheckDidSucceedFor(_ bookingContext: BookingContext)
    func availabilityCheckDidFailWith(_ error: Error)
}
