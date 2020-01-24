//
//  CalendarMonthCell.swift
//  TravelerKitUI
//
//  Created by Josip Petric on 23/01/2020.
//  Copyright © 2020 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

protocol CalendarMonthCellDataSource: class {
    func calendarMonthCell(_ cell: CalendarMonthCell, isDateSelected date: Date) -> Bool
    func calendarMonthCell(_ cell: CalendarMonthCell, availabilityStateForDate date: Date) -> AvailabilityState
}

protocol CalendatMonthCellDelegate: class {
    func calendarMonthCell(_ cell: CalendarMonthCell, didSelectDate date: Date)
}

class CalendarMonthCell: UICollectionViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: CalendatMonthCellDelegate?
    weak var dataSource: CalendarMonthCellDataSource? {
        didSet {
            collectionView.reloadData()
        }
    }
    var month: Month?

    var dateSelectionIndicatorColor: UIColor?
    var dateSelectionIndicatorTextColor: UIColor?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "CalendarDayCell", bundle: Bundle(for: type(of: self))), forCellWithReuseIdentifier: CellIdentifiers.calendarDayItem)
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = UIEdgeInsets(top: 20.0, left: 0.0, bottom: 0.0, right: 0.0)
        }
    }
}

extension CalendarMonthCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dayItemWidth = collectionView.bounds.width / CGFloat(CalendarView.maxNumberOfDaysInWeek)
        return CGSize(width: dayItemWidth, height: dayItemWidth - 8)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // Fill the whole collection view with cells. In `collectionView:cellForItemAt` will be determined
        // whether certain cell will show a date or will it be empty and non-selectable.
        return CalendarView.maxNumberOfDaysInWeek * CalendarView.maxNumberOfRowsPerMonth
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.calendarDayItem, for: indexPath)
        guard let month = month else {
            Log("Calendar month view missing data", data: nil, level: .warning)
            return cell
        }
        if let dayCell = cell as? CalendarDayCell {
            dayCell.selectionIndicatorColor = dateSelectionIndicatorColor
            dayCell.selectionIndicatorTextColor = dateSelectionIndicatorTextColor
            
            let monthOffset = calculateMonthOffset(with: month)
            let dayNumber = calculateDayNumber(forIndexPath: indexPath, withMonthOffset: monthOffset)
            if indexPath.item < monthOffset || dayNumber > month.daysInMonth {
                dayCell.isUserInteractionEnabled = false
                dayCell.valueLabel.text = nil
            } else {
                dayCell.isUserInteractionEnabled = true
                dayCell.valueLabel.text = "\(dayNumber)"
                
                if let dataSource = dataSource,
                    let date = createDate(withDay: dayNumber, andMonth: month) {
                    dayCell.isSelected = dataSource.calendarMonthCell(self, isDateSelected: date)
                    dayCell.availabilityState = dataSource.calendarMonthCell(self, availabilityStateForDate: date)
                } else {
                    dayCell.availabilityState = .notDetermined
                }
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let month = month else {
            Log("Calendar month view missing data", data: nil, level: .warning)
            return
        }
        let monthOffset = calculateMonthOffset(with: month)
        var dateComponents = DateComponents()
        dateComponents.year = month.year
        dateComponents.month = month.monthIndex + 1
        dateComponents.day = calculateDayNumber(forIndexPath: indexPath, withMonthOffset: monthOffset)
        if let selectedDate = month.calendar.date(from: dateComponents) {
            Log("Selected date: \(selectedDate)", data: nil, level: .debug)
            delegate?.calendarMonthCell(self, didSelectDate: selectedDate)
        }
        // Reload data in case there already is a selected item in the current month.
        // If data is not reloaded, there would be two dates selected at the same time.
        collectionView.reloadData()
    }
    
    private func calculateMonthOffset(with month: Month) -> Int {
        var monthOffset = (month.firstDayInMonth.rawValue - month.firstDayOfWeek.rawValue)
        if monthOffset < 0 {
            monthOffset = DayOfWeek.allCases.count + monthOffset
        }
        return monthOffset
    }
    
    private func calculateDayNumber(forIndexPath indexPath: IndexPath, withMonthOffset monthOffset: Int) -> Int {
        return (indexPath.item + 1) - monthOffset
    }
    
    private func createDate(withDay day: Int, andMonth month: Month) -> Date? {
        var dateComponents = DateComponents()
        dateComponents.day = day
        dateComponents.month = month.monthIndex + 1
        dateComponents.year = month.year
        return month.calendar.date(from: dateComponents)
    }
}
