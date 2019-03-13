//
//  AvailabilitiesFetchDelegate.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-03-12.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public protocol AvailabilitiesFetchDelegate: class {
    func availabilitiesFetchDidFailWith(_ error: Error)
    func availabilitiesFetchDidSucceedWith(_ availabilities: [Availability])
}
