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
        let locale = Locale(identifier: currencyCode)

        let numberFormatter = NumberFormatter()
        numberFormatter.locale = locale
        numberFormatter.numberStyle = .currency

        return numberFormatter.string(for:self)
    }
}
