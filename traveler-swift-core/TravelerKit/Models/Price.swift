//
//  Price.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-02-01.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public struct Price: Decodable {
    public let value: Double
    public let currency: String

    public var localizedDescription: String? {
        return value.priceDescription(currencyCode: currency)
    }
}
