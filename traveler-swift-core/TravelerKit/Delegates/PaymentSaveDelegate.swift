//
//  PaymentSaveDelegate.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-11-18.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public protocol PaymentSaveDelegate: class {
    func savePaymentDidSucceed()
    func savePaymentDidFailWith(_ error: Error)
}
