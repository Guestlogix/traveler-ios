//
//  BookingFormFetchDelegate.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-03-12.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// Notified of booking form fetch results
public protocol BookingFormFetchDelegate: class {
    /**
     Called when there was as error processing the order

     - Parameters:
     - error: The `Error` representing the reason for failure. No specific errors
     to look for here. Best coarse of action is to just display a generic error
     message.
     */
    func bookingFormFetchDidFailWith(_ error: Error)
    /**
     Called when the booking form was fetched successfully

     - Parameters:
     - bookingForm: Fetched `BookingForm`
     */
    func bookingFormFetchDidSucceedWith(_ bookingForm: BookingForm)
}
