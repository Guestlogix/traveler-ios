//
//  ScheduleFetchDelegate.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-11-23.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public protocol AvailabilityFetchDelegate: class {
    func availabilityFetchDidSucceedWith(_ result: [Availability])
    func availabilityFetchDidFailWith(_ error: Error)
}
