//
//  Calendar+TravelerKit.swift
//  TravelerKit
//
//  Created by Ben Ruan on 2019-10-18.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

extension Calendar {
    public func monthInterval(for date: Date) -> DateInterval? {
        let calendar = Calendar.current

        let interval = calendar.dateInterval(of: .month, for: date)
        guard let startDate = interval?.start, let intervalEnd = interval?.end, let endDate = calendar.date(byAdding: .day, value: -1, to: intervalEnd) else {
            Log("Unknow error getting month interval for date.", data: date, level: .error)
            return nil
        }

        return DateInterval.init(start: startDate, end: endDate)
    }

    public func numberOfDaysInCorrespondingMonth(for date: Date) -> Int? {
        let range = Calendar.current.range(of: .day, in: .month, for: date)
        return range?.count
    }
}
