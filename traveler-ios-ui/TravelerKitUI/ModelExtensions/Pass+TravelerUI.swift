//
//  Pass+TravelerUI.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-04-04.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit

extension Dictionary where Key == Pass, Value == Int {
    var subTotalDescription: String? {
        var value: Double = 0

        for (pass, quantity) in self {
            value += (Double(quantity) * pass.price.value)
        }

        return value.priceDescription()
    }
}
