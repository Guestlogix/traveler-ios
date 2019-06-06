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
    func subTotalDescription(in currency: Currency) -> String? {
        var value: Price = 0.0

        for (pass, quantity) in self {
            do {
                try value += (Double(quantity) * pass.price)
            } catch {
                Log("Error performing Price arithmetic", data: self, level: .error)
                return nil
            }
        }

        return value.localizedDescription(in: currency)
    }
}
