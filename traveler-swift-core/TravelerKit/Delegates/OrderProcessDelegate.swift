//
//  OrderProcessDelegate.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-02-01.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public protocol OrderProcessDelegate: class {
    func order(_ order: Order, didSucceedWithReceipt receipt: Receipt)
    func order(_ order: Order, didFailWithError error: Error)
}
