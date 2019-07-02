//
//  ProcessedPayment.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-06-19.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// This type is used to provide payment information on processed orders
public struct ProcessedPaymentInfo: Decodable {
    /// Information on payment used in order
    public let paymentInfo: String
}
