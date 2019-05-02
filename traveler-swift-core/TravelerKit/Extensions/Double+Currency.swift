//
//  Double+Currency.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-02-04.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

extension Double {
    public func priceDescription(currencyCode: String = "USD") -> String? {
        guard let locale = Locale(currencyCode: currencyCode) else {
            return nil
        }

        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale.current
        numberFormatter.currencySymbol = locale.currencySymbol
        numberFormatter.numberStyle = .currency

        return numberFormatter.string(for: self)
    }
}

extension Locale {
    private static var currencyLocales: [String: Locale] = [:]

    init?(currencyCode: String) {
        if let locale = Locale.currencyLocales[currencyCode] {
            self = locale
        } else if let locale = Locale.availableIdentifiers.map({ Locale(identifier: $0) }).first(where: { $0.currencyCode == currencyCode }) {

            self = locale
        } else {
            return nil
        }
    }
}
