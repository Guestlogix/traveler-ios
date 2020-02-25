//
//  Date+Day.swift
//  TravelerKitUI
//
//  Created by Rakin Hoque on 2019-12-13.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation

extension Date {
    public func minTimeOfDay() -> Date {
        // Time: 00:00:00
        let components = Calendar.current.dateComponents([.era, .year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }
    
    public func maxTimeOfDay() -> Date {
        // Time: 23:59:59
        var components = Calendar.current.dateComponents([.era, .year, .month, .day], from: self)
        components.hour = 23
        components.minute = 59
        components.second = 59
        let date = Calendar.current.date(from: components)
        return date!
    }
}
