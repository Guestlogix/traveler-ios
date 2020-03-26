//
//  Discount.swift
//  TravelerKit
//
//  Created by Josip Petric on 26/03/2020.
//  Copyright © 2020 Guestlogix. All rights reserved.
//

import Foundation

/// Represents the different statuses a `Discount` can have
public enum DisountCouponStatus {
    /// The `DiscountCoupon` is being processed
    case pending
    /// The `DiscountCoupon` is applied and is visible in total price calculation
    case applied
    /// The `DiscountCoupon` status is unknown
    case unknown
}

/// Holds information about a discount.
public struct DiscountCoupon: Decodable {
    /// `DiscountStatus` of the current discount
    public let status: DisountCouponStatus
    /// The title or name of the `Discount`. Explains what the `Discount` is about.
    public let title: String
    /// The Terms and Conditions URL for the `Discount`
    public let termsAndConditions: URL
    /// The amount of the `Discount`
    public let amount: Price
    /// The `Discount` token
    public let discountToken: String
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case title = "label"
        case termsAndConditions = "termsAndConditions"
        case amount = "amount"
        case discountToken = "discountToken"
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let statusString = try container.decode(String.self, forKey: .status)
        switch statusString.lowercased() {
        case "pending":
            self.status = .pending
        case "applied":
            self.status = .applied
        default:
            self.status = .unknown
        }
        
        self.title = try container.decode(String.self, forKey: .title)
        self.termsAndConditions = try container.decode(URL.self, forKey: .termsAndConditions)
        self.amount = try container.decode(Price.self, forKey: .amount)
        self.discountToken = try container.decode(String.self, forKey: .discountToken)
    }
}
