//
//  NumberFormatter+TravelerKit.swift
//  TravelerKit
//
//  Created by Dorothy Fu on 2019-04-09.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

extension NumberFormatter {
    public static func currency(currency: String) -> NumberFormatter {
        let numberFormatter = NumberFormatter()
        let locale = NSLocale(localeIdentifier: currency)
        numberFormatter.locale = Locale.current
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = locale.displayName(forKey: .currencySymbol, value: currency)

        return numberFormatter
    }
}
