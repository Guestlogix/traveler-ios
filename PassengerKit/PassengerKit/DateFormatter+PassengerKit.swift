//
//  DateFormatter+PassengerKit.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-10-01.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

extension DateFormatter {
    static var yearMonthDay: DateFormatter = {
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter
    }()
}
