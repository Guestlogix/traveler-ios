//
//  Calendar.swift
//  TravelerKitUI
//
//  Created by Josip Petric on 24/01/2020.
//  Copyright © 2020 GuestLogix. All rights reserved.
//

import Foundation

/// Days of the week. By setting you calandar's first day of week,
/// you can change which day is the first for the week. Sunday is by default.
public enum DayOfWeek: Int, CaseIterable {
    /// Days of the week.
    case sunday = 0, monday, tuesday, wednesday, thursday, friday, saturday
    
    func name(fromCalendar calendar: Calendar) -> String {
        let dayIndex = self.rawValue
        if calendar.weekdaySymbols.count > dayIndex {
            return calendar.shortWeekdaySymbols[dayIndex]
        }
        return ""
    }
}

struct Month {
    let calendar: Calendar
    let monthIndex: Int
    let year: Int
    let daysInMonth: Int
    let firstDayInMonth: DayOfWeek
    let firstDayOfWeek: DayOfWeek
}
