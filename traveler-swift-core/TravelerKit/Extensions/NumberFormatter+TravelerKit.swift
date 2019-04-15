//
//  NumberFormatter+TravelerKit.swift
//  TravelerKit
//
//  Created by Dorothy Fu on 2019-04-09.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

extension NumberFormatter {
    public static func currencyFormatter(_ code: String) -> NumberFormatter {
        let numberFormatter = NumberFormatter()
        let locale = NSLocale(localeIdentifier: code)
        numberFormatter.locale = Locale.current
        numberFormatter.numberStyle = .currency
        numberFormatter.currencySymbol = locale.displayName(forKey: .currencySymbol, value: code)

        return numberFormatter
    }
}
