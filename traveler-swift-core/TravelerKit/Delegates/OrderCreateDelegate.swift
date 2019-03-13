//
//  OrderCreateDelegate.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-01-25.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public protocol OrderCreateDelegate: class {
    func orderCreationDidSucceed(_ order: Order)
    func orderCreationDidFail(_ error: Error)
}
