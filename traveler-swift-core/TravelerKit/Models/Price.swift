//
//  Price.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-02-01.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// All prices come in this type that represents the value as well as the currency of the amount.
public struct Price: Decodable {
    /// The nominal value of the amount
    public let value: Double
    /// A three character `String` representing the currency of the amount.
    public let currency: String

    /// A convenience computed property for displaying a localized description of the amount. e.g. "$431.23"
    public var localizedDescription: String? {
        let numberFormatter = NumberFormatter()
        let locale = NSLocale(localeIdentifier: currency)
        numberFormatter.locale = Locale.current
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = locale.displayName(forKey: .currencySymbol, value: currency)

        return numberFormatter.string(for: self.value)
    }
}
