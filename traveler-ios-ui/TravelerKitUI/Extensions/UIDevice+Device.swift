//
//  UIDevice+Device.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-02-11.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit

extension UIDevice: Device {
    public var identifier: String {
        return identifierForVendor?.uuidString ?? "[NO_DEVICE_ID]"
    }

    public var osVersion: String {
        return "\(systemName) \(systemVersion)"
    }
}
