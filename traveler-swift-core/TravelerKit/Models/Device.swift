//
//  Device.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-02-08.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// This represents the device that the SDK is running on.
public protocol Device {
    /// A unique identifier of the device. In case of iOS this would be vendorId
    var identifier: String { get }
    /// A string representing the current version of the OS running on the device.
    var osVersion: String { get }
}
