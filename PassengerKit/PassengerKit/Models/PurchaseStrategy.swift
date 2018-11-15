//
//  PurchaseStrategy.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-11-13.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public enum PurchaseStrategy: Int, Decodable {
    case bookable = 1 // = "bookable"
    case buyable = 0 // = "buyable"
}
