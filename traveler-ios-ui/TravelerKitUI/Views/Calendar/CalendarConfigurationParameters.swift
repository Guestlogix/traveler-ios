//
//  CalendarConfigurationParameters.swift
//  TravelerKitUI
//
//  Created by Josip Petric on 23/01/2020.
//  Copyright © 2020 GuestLogix. All rights reserved.
//

import Foundation

/// Parameters used by `CalendarView`.
/// `CalendarConfigurationParameters` are used to create data model,
/// setup UI and working logic.
public struct CalendarConfigurationParameters {
    /// The start date boundary of the calendar
    public var startDate: Date
    /// The end-date boundary of the calendar
    public var endDate: Date
    /// Set `seslectedDate` if calendar needs to pre-select a specific date
    public var selectedDate: Date?
    /// calendar() Instance
    public var calendar: Calendar
    /// Sets the color for date selection indicator
    public var dateSelectionColor: UIColor
    /// Sets the color of the selected date text
    public var dateSelectionTextColor: UIColor
    /// Sets the first day of week
    public var firstDayOfWeek: DayOfWeek = .sunday
}
