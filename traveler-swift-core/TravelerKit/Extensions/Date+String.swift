//
//  Date+String.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-07-11.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

extension Date {
    public func description(with timeZone: TimeZone, formatter: DateFormatter) -> String {
        let formatterCopy = formatter.copy() as! DateFormatter
        formatterCopy.timeZone = timeZone
        return formatter.string(from: self)
    }
}
