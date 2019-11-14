//
//  PaymentManager.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-11-13.
//  Copyright © 2019 Guestlogix. All rights reserved.
//

import Foundation

public protocol PaymentManager {
    static func fetchPayments(delegate: PaymentsFetchDelegate)
    static func fetchPayments(completion: @escaping ([Payment]?, Error?) -> Void)
    static func savePayment(_ payment: Payment, completion: @escaping ((Error?) -> Void))
    static func savePayment(_ payment: Payment, delegate: PaymentSaveDelegate)
}
