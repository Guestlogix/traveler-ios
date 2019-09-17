//
//  PriceRange.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-08-19.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation
/**
 A model represeting a filter that relates to range of prices.
 */
public struct PriceRange: Equatable {
    /// The range of prices with which the items should be filtered
    public let range: ClosedRange<Double>
    /// The currency representing the range of prices
    public let currency: Currency

    public init(range: ClosedRange<Double>, currency: Currency) {
        self.range = range
        self.currency = currency
    }
}
