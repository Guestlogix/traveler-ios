//
//  CalendarView.swift
//  TravelerKitUI
//
//  Created by Josip Petric on 23/01/2020.
//  Copyright © 2020 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

public protocol CalendarViewDataSource: class {
    /// Calendar uses `ConfigurationParameters` to create calendar model and UI.
    func configurationParameters(for calendarVew: CalendarView) -> CalendarConfigurationParameters
    /// Method is called when data source is done initializing model for the `CalendarView`.
    func calendarView(_ view: CalendarView, didInitWithFirstMonthStartDate startDate: Date, andEndDate endDate: Date)
    /// `AvailabilityState` determines whether a certain `Date` can be selected or not. It also determines `Date`
    /// UI presentation in the `CalendarView`
    func calendarView(_ calendarView: CalendarView, availabilityStateForDate date: Date) -> AvailabilityState
}

public protocol CalendarViewDelegate: class {
    /// Called when `Date` has been selected in the `CalendarView`.
    func calendarView(_ view: CalendarView, didSelectDate date: Date)
    /// Called when calendar month has been changed. Calendar month can be changed either by user swipe gesture or
    /// by user tapping on next/previous arrows. `startDate` and `endDate` are start and end date for the currently
    /// visible month (after it has been changed) in the `CalendarView`.
    func calendarView(_ view: CalendarView, didChangeMonthWithStartDate startDate: Date, andEndDate endDate: Date)
}

public class CalendarView: UIView {

    public weak var dataSource: CalendarViewDataSource? {
        didSet {
            // CalendarView's model and UI updates must be
            // made and updated once there is data source available.
            createCalendarModel()
            updateUI()
        }
    }
    public weak var delegate: CalendarViewDelegate?

    /// Holds selected `Date` in the calendar. If `Date` is not
    /// selected, variable will be nil
    public var selectedDate: Date?
    
    private weak var titleLabel: UILabel!
    private weak var previousButton: UIButton!
    private weak var nextButton: UIButton!
    private weak var daysStackView: UIStackView!
    private weak var separatorView: UIView!
    private weak var collectionView: UICollectionView!
    private weak var activityIndicator: UIActivityIndicatorView!
    
    static let maxNumberOfDaysInWeek = 7
    static let maxNumberOfRowsPerMonth = 6
    
    private var collectionViewHeight = CGFloat.zero
    /// `months` is a array of `Month` objects built using `CalendarConfigurtionParameters`.
    /// It is collections view's data source.
    private var months: [Month] = []
    private static let padding: CGFloat = 4.0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    /// Shows loading animation and disables user interaction with the `CalendarView`.
    public func startLoadingIndicator() {
        activityIndicator.startAnimating()
        isUserInteractionEnabled = false
        nextButton.isEnabled = false
        previousButton.isEnabled = false
        collectionView.alpha = 0.4
    }
    
    /// Hides loading animation and enables user interaction with the `CalendarView`.
    ///
    /// - Parameters:
    ///     - refresh: determines whether calendar component will be refreshed once loading indicator is stopped and removed
    public func stopLoadingIndicator(withCalendarRefresh refresh: Bool) {
        activityIndicator.stopAnimating()
        isUserInteractionEnabled = true
        nextButton.isEnabled = true
        previousButton.isEnabled = true
        collectionView.alpha = 1.0
        if refresh {
            reloadCalendar()
        }
    }
    
    /// Refreshes calendar component.
    public func reloadCalendar() {
        collectionView.reloadData()
    }

    override public var intrinsicContentSize: CGSize {
        guard nextButton != nil && daysStackView != nil && collectionView != nil else {
            return CGSize.zero
        }
        let height = 2 * CalendarView.padding + nextButton.bounds.height +
            CalendarView.padding + daysStackView.bounds.height +
            CalendarView.padding + collectionView.bounds.height
        return CGSize(width: UIView.noIntrinsicMetric, height: height)
    }
    
    func commonInit() {
        translatesAutoresizingMaskIntoConstraints = false
        
        // Create month and year title label
        let titleLabel = UILabel()
        if #available(iOS 13.0, *) {
            titleLabel.textColor = .label
        } else {
            titleLabel.textColor = .black
        }
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        
        // Create next and previous month buttons
        let buttonsColor: UIColor
        if #available(iOS 13.0, *) {
            buttonsColor = .label
        } else {
            buttonsColor = .black
        }
        let nextButton = ArrowRightButton()
        nextButton.tintColor = buttonsColor
        nextButton.addTarget(self, action: #selector(CalendarView.nextButtonPressed(_:)), for: .touchUpInside)
        
        let previousButton = ArrowLeftButton()
        previousButton.tintColor = buttonsColor
        previousButton.addTarget(self, action: #selector(CalendarView.previousButtonPressed(_:)), for: .touchUpInside)
        
        // Create stack view with days
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.backgroundColor = .clear
        for _ in 0..<CalendarView.maxNumberOfDaysInWeek {
            let label = UILabel()
            if #available(iOS 13.0, *) {
                label.textColor = .secondaryLabel
            } else {
                label.textColor = .lightGray
            }
            label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            label.textAlignment = .center
            stackView.addArrangedSubview(label)
        }
        
        // Add separator line between days stack view and month collection view
        let separatorView = UIView()
        if #available(iOS 13.0, *) {
            separatorView.backgroundColor = .tertiaryLabel
        } else {
            separatorView.backgroundColor = .lightGray
        }
        separatorView.alpha = 0.7
        
        // Create collection view that will show calendar
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets.zero
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.backgroundColor = .clear
        collection.bounces = false
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        collection.isPagingEnabled = true
        collection.bounces = true
        collection.dataSource = self
        collection.delegate = self
        collection.register(UINib(nibName: "CalendarMonthCell", bundle: Bundle(for: type(of: self))), forCellWithReuseIdentifier: CellIdentifiers.calendarMonthItem)
        
        // Setting up activity indicator view
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.hidesWhenStopped = true
        
        addSubview(titleLabel)
        addSubview(nextButton)
        addSubview(previousButton)
        addSubview(stackView)
        addSubview(separatorView)
        addSubview(collection)
        addSubview(indicator)
        
        self.titleLabel = titleLabel
        self.nextButton = nextButton
        self.previousButton = previousButton
        self.daysStackView = stackView
        self.collectionView = collection
        self.separatorView = separatorView
        self.activityIndicator = indicator
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        previousButton.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraints([
            nextButton.topAnchor.constraint(equalTo: topAnchor, constant: 2 * CalendarView.padding),
            nextButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            nextButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            nextButton.widthAnchor.constraint(equalToConstant: 30),
            nextButton.heightAnchor.constraint(equalToConstant: 30),
            previousButton.topAnchor.constraint(equalTo: nextButton.topAnchor),
            previousButton.trailingAnchor.constraint(equalTo: nextButton.leadingAnchor, constant: -8),
            previousButton.widthAnchor.constraint(equalTo: nextButton.widthAnchor),
            previousButton.heightAnchor.constraint(equalTo: nextButton.heightAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            stackView.topAnchor.constraint(equalTo: nextButton.bottomAnchor, constant: CalendarView.padding),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            separatorView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            separatorView.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: CalendarView.padding),
            separatorView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            collectionView.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: CalendarView.padding),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: calculateMonthItemHeight()),
            activityIndicator.centerXAnchor.constraint(equalTo: collection.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: collection.centerYAnchor)
        ])
    }
    
    private func calculateMonthItemHeight() -> CGFloat {
        let width = UIScreen.main.bounds.width - 2*CalendarView.padding
        let dayItemWidth = width / CGFloat(CalendarView.maxNumberOfDaysInWeek)
        let monthItemHeight = (dayItemWidth - 4) * CGFloat(CalendarView.maxNumberOfRowsPerMonth)
        return monthItemHeight
    }
    
    private func createCalendarModel() {
        guard let calendarParameters = dataSource?.configurationParameters(for: self) else {
            Log("Calendar missing configuration parameters", data: nil, level: .warning)
            return
        }
        let calendar = calendarParameters.calendar
        // Make start date be the first day of the calendarParameters.startDate month.
        var dateComponents = DateComponents()
        dateComponents.day = 1
        dateComponents.month = calendar.component(.month, from: calendarParameters.startDate)
        dateComponents.year = calendar.component(.year, from: calendarParameters.startDate)
        let calendarStartDate = calendar.date(from: dateComponents)!
        
        guard let monthsDiff = calendarParameters.calendar.dateComponents(
            [.month], from: calendarStartDate, to: calendarParameters.endDate).month else {
            Log("Calendar cannot create calendar months model", data: nil, level: .warning)
            return
        }
        months = []
        
        let startDateMonthIndex = calendarParameters.calendar.component(.month, from: calendarStartDate)
        // Add one more month since start date and end date can be in the same month and
        // then we would get 0 number of months
        let numberOfMonths = monthsDiff + 1
        for index in 0..<numberOfMonths {
            let monthIndex = ((index + startDateMonthIndex) - 1) % calendar.monthSymbols.count
            // Create a date in this month to check what year it is
            var dateComponents = DateComponents()
            dateComponents.month = index
            if let date = calendar.date(byAdding: dateComponents, to: calendarStartDate),
                let range = calendar.range(of: .day, in: .month, for: date) {
                let year = calendar.component(.year, from: date)
                let daysInMonth = range.count
                
                // Create the first day in month to check with what weekday month begins
                dateComponents = DateComponents()
                dateComponents.day = 1
                dateComponents.month = calendar.component(.month, from: date)
                dateComponents.year = calendar.component(.year, from: date)
                let firstDayInMonth = calendar.date(from: dateComponents)!
                if let firstWeekdayInMonth = DayOfWeek(rawValue: calendar.component(.weekday, from: firstDayInMonth) - 1) {
                    let month = Month(calendar: calendarParameters.calendar,
                                      monthIndex: monthIndex,
                                      year: year,
                                      daysInMonth: daysInMonth,
                                      firstDayInMonth: firstWeekdayInMonth,
                                      firstDayOfWeek: calendarParameters.firstDayOfWeek)
                    months.append(month)
                }
            }
        }
        notifyDateSourceAboutInitCompletion(months: months, calendar: calendar)
    }
    
    private func notifyDateSourceAboutInitCompletion(months: [Month], calendar: Calendar) {
        guard let firstMonth = months.first else {
            Log("Calendar data model is not set or there there is no data. There should be at least one month in the calendar.", data: nil, level: .warning)
            return
        }
        var dateComponents = DateComponents()
        dateComponents.day = 1
        dateComponents.month = firstMonth.monthIndex + 1
        dateComponents.year = firstMonth.year
        let startDate = calendar.date(from: dateComponents)
        
        dateComponents.day = firstMonth.daysInMonth
        let endDate = calendar.date(from: dateComponents)
        
        if let startDate = startDate, let endDate = endDate {
            dataSource?.calendarView(self, didInitWithFirstMonthStartDate: startDate, andEndDate: endDate)
        }
    }
    
    private func updateUI() {
        guard let configParams = dataSource?.configurationParameters(for: self) else {
            Log("Calendar missing configuration parameters", data: nil, level: .warning)
            return
        }
        guard daysStackView.arrangedSubviews.count == DayOfWeek.allCases.count else {
            Log("Calendar days view not configured", data: nil, level: .warning)
            return
        }
        if !months.isEmpty {
            setCalendarTitle(forMonth: months[0])
        }
        // Setup days of the week based on selected first day of week
        let firstDay = configParams.firstDayOfWeek.rawValue
        let daysOfWeek = DayOfWeek.allCases.count
        for index in 0..<daysOfWeek {
            if let weekDay = DayOfWeek(rawValue: ((firstDay + index) % daysOfWeek)),
                let dayLabel = daysStackView.arrangedSubviews[index] as? UILabel {
                dayLabel.text = weekDay.name(fromCalendar: configParams.calendar)
            }
        }
        updateCalendarNavigationButtons(for: IndexPath(item: 0, section: 0))
    }
    
    private func setCalendarTitle(forMonth month: Month) {
        guard let calendar = dataSource?.configurationParameters(for: self).calendar else {
            Log("Calendar missing configuration parameters", data: nil, level: .warning)
            return
        }
        let calendarMonths = calendar.monthSymbols
        if month.monthIndex < calendarMonths.count {
            titleLabel.text = "\(calendarMonths[month.monthIndex]) \(month.year)"
        } else {
            titleLabel.text = ""
        }
    }
    
    private func updateCalendarNavigationButtons(for indexPath: IndexPath) {
        previousButton.isEnabled = indexPath.item != 0
        nextButton.isEnabled = indexPath.item + 1 < months.count
    }
    
    @objc func nextButtonPressed(_ sender: UIButton) {
        guard let currentVisibleIndexPath = getCurrentlyVisibleIndexPath() else {
            Log("Calendar should have at least one month shown", data: nil, level: .warning)
            return
        }
        // Make sure there is next item in data source
        if currentVisibleIndexPath.item + 1 < months.count {
            let nextIndexPath = IndexPath(item: currentVisibleIndexPath.item + 1, section: currentVisibleIndexPath.section)
            collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
            updateCalendarNavigationButtons(for: nextIndexPath)
        }
    }
    
    @objc func previousButtonPressed(_ sender: UIButton) {
        guard let currentVisibleIndexPath = getCurrentlyVisibleIndexPath() else {
            Log("Calendar should have at least one month shown", data: nil, level: .warning)
            return
        }
        // Make sure previous item is still in bounds of the data source
        if currentVisibleIndexPath.item - 1 >= 0 {
            let previousIndexPath = IndexPath(item: currentVisibleIndexPath.item - 1, section: currentVisibleIndexPath.section)
            collectionView.scrollToItem(at: previousIndexPath, at: .centeredHorizontally, animated: true)
            updateCalendarNavigationButtons(for: previousIndexPath)
        }
    }
}

extension CalendarView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bounds.width, height: calculateMonthItemHeight())
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return months.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CellIdentifiers.calendarMonthItem, for: indexPath)
        if let monthCell = cell as? CalendarMonthCell {
            let month = months[indexPath.item]
            monthCell.month = month
            monthCell.dateSelectionIndicatorColor = dataSource?.configurationParameters(for: self).dateSelectionColor
            monthCell.dateSelectionIndicatorTextColor = dataSource?.configurationParameters(for: self).dateSelectionTextColor
            monthCell.delegate = self
            monthCell.dataSource = self
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let monthCell = cell as? CalendarMonthCell {
            deselectAllSelectedItems(in: monthCell.collectionView)
            monthCell.collectionView.reloadData()
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        collectionViewDidEndScrolling()
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            collectionViewDidEndScrolling()
        }
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        collectionViewDidEndScrolling()
    }
    
    private func collectionViewDidEndScrolling() {
        guard let indexPath = getCurrentlyVisibleIndexPath() else {
            Log("Calendar should have at least one month shown", data: nil, level: .warning)
            return
        }
        let month = months[indexPath.item]
        setCalendarTitle(forMonth: month)
        updateCalendarNavigationButtons(for: indexPath)
        var dateComponents = DateComponents()
        dateComponents.day = 1
        dateComponents.month = month.monthIndex + 1
        dateComponents.year = month.year
        let startDate = month.calendar.date(from: dateComponents)
        
        dateComponents.day = month.daysInMonth > 31 ? 31 : month.daysInMonth
        dateComponents.month = month.monthIndex + 1
        dateComponents.year = month.year
        let endDate = month.calendar.date(from: dateComponents)
        
        if let startDate = startDate, let endDate = endDate {
            Log("Month did change (\(startDate) - \(endDate))", data: nil, level: .debug)
            delegate?.calendarView(self, didChangeMonthWithStartDate: startDate, andEndDate: endDate)
        }
    }
    
    private func deselectAllSelectedItems(in collectionView: UICollectionView) {
        guard let selectedItems = collectionView.indexPathsForSelectedItems else { return }
        for indexPath in selectedItems {
            collectionView.deselectItem(at: indexPath, animated: false)
        }
    }
    
    private func getCurrentlyVisibleIndexPath() -> IndexPath? {
        guard let indexPath = collectionView.visibleCells.max(by: {
            let intersect0 = collectionView.bounds.intersection($0.frame)
            let intersect1 = collectionView.bounds.intersection($1.frame)
            return intersect1.width > intersect0.width
        }).flatMap({
            return collectionView.indexPath(for: $0)
        }) else {
            return nil
        }
        return indexPath
    }
}

extension CalendarView: CalendarMonthCellDataSource {
    func calendarMonthCell(_ cell: CalendarMonthCell, isDateSelected date: Date) -> Bool {
        if let preselectedDate = dataSource?.configurationParameters(for: self).selectedDate,
        selectedDate == nil && preselectedDate.minTimeOfDay() == date.minTimeOfDay() {
            return true
        }
        if let selectedDate = selectedDate, selectedDate == date {
            return true
        }
        return false
    }
    
    func calendarMonthCell(_ cell: CalendarMonthCell, availabilityStateForDate date: Date) -> AvailabilityState {
        return dataSource?.calendarView(self, availabilityStateForDate: date) ?? AvailabilityState.notDetermined
    }
}

extension CalendarView: CalendatMonthCellDelegate {
    func calendarMonthCell(_ cell: CalendarMonthCell, didSelectDate date: Date) {
        selectedDate = date
        delegate?.calendarView(self, didSelectDate: date)
    }
}
