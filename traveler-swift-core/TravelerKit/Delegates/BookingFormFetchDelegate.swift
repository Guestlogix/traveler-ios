//
//  BookingFormFetchDelegate.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-03-12.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public protocol BookingFormFetchDelegate: class {
    func bookingFormFetchDidFailWith(_ error: Error)
    func bookingFormFetchDidSucceedWith(_ bookingForm: BookingForm)
}
