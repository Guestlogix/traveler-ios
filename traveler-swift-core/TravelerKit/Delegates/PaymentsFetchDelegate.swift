//
//  PaymentsFetchDelegate.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-11-13.
//  Copyright © 2019 Guestlogix. All rights reserved.
//

import Foundation

public protocol PaymentsFetchDelegate: class {
    func paymentsFetchDidSucceedWith(_ result: [Payment])
    func paymentsFetchDidFailWith(_ error: Error)
}
