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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        return dateFormatter
    }()

    static var withoutTimezone: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        return formatter
    }()

    static var timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()

    static var longFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMMM d, yyyy"
        return formatter
    }()

    static var dateOnlyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
}
