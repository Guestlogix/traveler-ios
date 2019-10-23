//
//  MockDevice.swift
//  TravelerKitTests
//
//  Created by Rakin Hoque on 2019-11-05.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation
@testable import TravelerKit

struct MockDevice: Device
{
    var identifier = "Test_Device_ID"
    var osVersion = "Test_OS_Version"
}
