//
//  PurchaseType.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-10-01.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// Different types of product
public enum PurchaseType: String, Decodable {
    /// Experience or any product that has a booking nature
    case booking = "Bookable"
    /// Products that relate to parking
    case parking = "Parking"
    /// Products that relate to offerings from a GLX partner
    case partnerOffering = "Menu"
}
