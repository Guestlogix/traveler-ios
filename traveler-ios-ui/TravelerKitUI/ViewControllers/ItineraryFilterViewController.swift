//
//  ItineraryFilterViewController.swift
//  TravelerKitUI
//
//  Created by Rakin Hoque on 2019-11-21.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

public protocol ItineraryFilterViewControllerDelegate: class {
    func itineraryFilterViewControllerDidApplyFilters(_ controller: ItineraryFilterViewController, types: [ItineraryItemType], dateRange: ClosedRange<Date>)
}

open class ItineraryFilterViewController: UITableViewController, CalendarViewDelegate, CalendarViewDataSource {
    
    private enum FilterSections: Int, CaseIterable {
        case type
        case dateRange
    }
    
    private let typeCellIdendifier = "TypeCell"
    private let rangeCellIdentifier = "RangeCell"
    private let dateFormat = "dd MMM yyyy"
    private var startDateCalendar: CalendarView?
    private var endDateCalendar: CalendarView?
    private var calendar: Calendar = {
        var cal = Calendar.current
        if let timeZone = TimeZone(secondsFromGMT: 0) {
            cal.timeZone = timeZone
        }
        return cal
    }()
    
    public weak var delegate: ItineraryFilterViewControllerDelegate?
    
    public var dateRange: ClosedRange<Date> = Date().minTimeOfDay() ... Date().maxTimeOfDay()
    public var types = [ItineraryItemType]()
    public var selectedTypes = [ItineraryItemType]()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: typeCellIdendifier)
        tableView.register(UINib(nibName: "RangeCell", bundle: Bundle(for: ItineraryFilterViewController.self)), forCellReuseIdentifier: rangeCellIdentifier)
        
        startDateCalendar = CalendarView()
        startDateCalendar?.dataSource = self
        startDateCalendar?.delegate = self
        
        endDateCalendar = CalendarView()
        endDateCalendar?.dataSource = self
        endDateCalendar?.delegate = self
    }
        
    @IBAction func didCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didApply() {
        delegate?.itineraryFilterViewControllerDidApplyFilters(self, types: self.selectedTypes, dateRange: self.dateRange)
        
        dismiss(animated: true, completion: nil)
    }
    
    override open func numberOfSections(in tableView: UITableView) -> Int {
        return FilterSections.allCases.count
    }
    
    override open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch FilterSections(rawValue: section) {
        case .type:
            return "Category"
        case .dateRange:
            return "Date range"
        default:
            Log("Unhandled title for section; this should not happen!", data: section, level: .error)
            return ""
        }
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch FilterSections(rawValue: section) {
        case .type:
            return types.count
        case .dateRange:
            return 1
        default:
            Log("Unhandled number of rows for section; this should not happen!", data: section, level: .error)
            return 0
        }
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch FilterSections(rawValue: indexPath.section) {
        case .type:
            let cell = tableView.dequeueReusableCell(withIdentifier: typeCellIdendifier, for: indexPath)
            cell.selectionStyle = .none
            
            switch types[indexPath.row] {
            case .booking:
                cell.textLabel?.text = "Experiences"
            case .flight:
                cell.textLabel?.text = "Flights"
            case .parking:
                cell.textLabel?.text = "Parking"
            case .transportation:
                cell.textLabel?.text = "Ground transfer"
            }
            
            if selectedTypes.contains(types[indexPath.row]) {
                cell.accessoryType = .checkmark
            } else {
                cell.accessoryType = .none
            }
            
            return cell
        case .dateRange:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            let cell = tableView.dequeueReusableCell(withIdentifier: rangeCellIdentifier, for: indexPath) as! RangeCell
            cell.selectionStyle = .none
            cell.titleLabel.text = "Date range"
            cell.startField.placeholder = "Enter the start date"
            cell.startField.text = dateFormatter.string(from: dateRange.lowerBound)
            cell.startField.inputView = startDateCalendar
            cell.endField.placeholder = "Enter the end date"
            cell.endField.text = dateFormatter.string(from: dateRange.upperBound)
            cell.endField.inputView = endDateCalendar
            return cell
        default:
            Log("Unhandled section for row; this should not happen!", data: indexPath, level: .error)
            
            return UITableViewCell()
        }
    }
    
    override public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if FilterSections(rawValue: indexPath.section) == .type {
            if let index = selectedTypes.index(of: types[indexPath.row]) {
                selectedTypes.remove(at: index)
            } else {
                selectedTypes.append(types[indexPath.row])
            }
        }
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    // MARK: - CalendarViewDataSource & CalendarViewDelegate
    
    public func configurationParameters(for calendarVew: CalendarView) -> CalendarConfigurationParameters {
        let startDate = dateRange.lowerBound
        var dateComponents = DateComponents()
        dateComponents.year = 50
        let endDate = self.calendar.date(byAdding: dateComponents, to: startDate) ?? dateRange.upperBound
        return CalendarConfigurationParameters(startDate: startDate,
                                               endDate: endDate,
                                               calendar: self.calendar,
                                               dateSelectionColor: UIColor.systemBlue,
                                               dateSelectionTextColor: UIColor.white,
                                               firstDayOfWeek: .sunday)
    }
    
    public func calendarView(_ view: CalendarView, didInitWithFirstMonthStartDate startDate: Date, andEndDate endDate: Date) {
        // noop
    }
    
    public func calendarView(_ calendarView: CalendarView, availabilityStateForDate date: Date) -> AvailabilityState {
        if calendarView === endDateCalendar {
            // Limit end date calendar to only allow selection for dates after start date
            let startDate = dateRange.lowerBound
            return date >= startDate ? .available : .unavailable
            
        } else if calendarView === startDateCalendar {
            // Limit start date calendar to only show dates in the past and in the current month
            if date <= Date().maxTimeOfDay() && date <= dateRange.upperBound {
                return .available
            } else {
                return .unavailable
            }
        }
        return .notDetermined
    }
    
    public func calendarView(_ view: CalendarView, didSelectDate date: Date) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: FilterSections.dateRange.rawValue)) as? RangeCell else {
            Log("RangeCell not found! This should not happen.", data: nil, level: .error)
            return
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        
        if view === startDateCalendar {
            dateRange = date ... dateRange.upperBound
            cell.startField.text = dateFormatter.string(from: date)
            // Calendar needs to be reloaded so that new date constraints are properly shown
            endDateCalendar?.reloadCalendar()

        } else if view === endDateCalendar {
            dateRange = dateRange.lowerBound ... date
            cell.endField.text = dateFormatter.string(from: date)
            // Calendar needs to be reloaded so that new date constraints are properly shown
            startDateCalendar?.reloadCalendar()
        }
    }
    
    public func calendarView(_ view: CalendarView, didChangeMonthWithStartDate startDate: Date, andEndDate endDate: Date) {
        // noop
    }
}
