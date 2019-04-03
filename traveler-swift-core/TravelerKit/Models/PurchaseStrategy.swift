//
//  PurchaseStrategy.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-13.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

/// Different strategies to purchase a product, a `Product` may only have one of these
public enum PurchaseStrategy: String, Decodable {
    /// Has a bookable nature like a tour
    case bookable = "Bookable"
    /// Has a buyable nature like an item to buy onboard a flight
    case buyable = "Buyable"
}
