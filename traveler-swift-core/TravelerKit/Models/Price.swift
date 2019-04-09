//
//  Price.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-02-01.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public enum PriceError: Error {
    case notMatching
}

/// All prices come in this type that represents the value as well as the currency of the amount.
public struct Price: Decodable {
    /// The nominal value of the amount
    public let value: Double
    /// A three character `String` representing the currency of the amount.
    public let currency: String

    /// A convenience computed property for displaying a localized description of the amount. e.g. "$431.23"
    public var localizedDescription: String? {
        return NumberFormatter.currency(currency: currency).string(for: value)
    }
}
