//
//  AvailabilityViewController.swift
//  TravelerKitUI
//
//  Created by Ben Ruan on 2019-08-14.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

public protocol AvailabilityViewControllerDelegate: class {
    func availabilityViewController(_ controller: AvailabilityViewController, didFinishWith purchaseForm: PurchaseForm)
}

open class AvailabilityViewController: UIViewController {
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    weak var delegate: AvailabilityViewControllerDelegate?

    var product: BookingItem?
    var selectedAvailability: Availability?
    var availabilityError: Error?
    var availableOptions: [BookingOption]? {
        return selectedAvailability?.optionSet?.options
    }
    var hasOptions: Bool {
        return availableOptions?.count ?? 0 > 0
    }
    var selectedOption: BookingOption?
    var optionsViewController: BookingOptionsViewController?

    private var passes: [Pass]?
    private var availabilities: [Date: Availability] = [:]
    
    private var calendarCellIndexPath: IndexPath {
        return IndexPath(row: 0, section: 0)
    }
    
    private var calendar: Calendar = {
        var cal = Calendar.current
        if let timeZone = TimeZone(secondsFromGMT: 0) {
            cal.timeZone = timeZone
        }
        return cal
    }()

    override open func viewDidLoad() {
        super.viewDidLoad()

        priceLabel.text = product?.price.localizedDescriptionInBaseCurrency
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
    }

    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as BookingOptionsViewController):
            vc.product = product
            vc.selectedAvailability = selectedAvailability
            vc.delegate = self
        case (_, let vc as BookingPassesViewController):
            vc.passes = passes
            vc.product = product
            vc.delegate = self
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    @IBAction func didProceed(_ sender: Any) {
        guard let product = product else {
            Log("No product", data: nil, level: .error)
            return
        }
        guard let availability = selectedAvailability else {
            if availabilityError == nil {
                availabilityError = BookingError.noDate
            }
            tableView.reloadData()
            return
        }
        nextButton.isEnabled = false

        if hasOptions == true {
            performSegue(withIdentifier: "optionSegue", sender: nil)
            nextButton.isEnabled = true
        } else {
            Traveler.fetchPasses(product: product, availability: availability, option: nil, delegate: self)
        }
    }
}

extension AvailabilityViewController: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Please select a date"
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: calendarCellIdentifier, for: indexPath) as! CalendarCell
        cell.calendarView.delegate = self
        cell.calendarView.dataSource = self
        return cell
    }
}

// MARK: - CalendarViewDataSource & CalendarViewDelegate

extension AvailabilityViewController: CalendarViewDataSource, CalendarViewDelegate {
    public func configurationParameters(for calendarVew: CalendarView) -> CalendarConfigurationParameters {
        let startDate = Date().minTimeOfDay()
        var dateComponents = DateComponents()
        dateComponents.year = 10
        let endDate = calendar.date(byAdding: dateComponents, to: startDate) ?? Date()
        
        return CalendarConfigurationParameters(startDate: startDate, endDate: endDate, calendar: calendar,
                                               dateSelectionColor: UIColor.systemBlue, dateSelectionTextColor: UIColor.white,
                                               firstDayOfWeek: .sunday)
    }
    
    public func calendarView(_ view: CalendarView, didInitWithFirstMonthStartDate startDate: Date, andEndDate endDate: Date) {
        // No need to check availabilities for past dates
        let today = Date().minTimeOfDay()
        updateCalendarAvailabilities(withStartDate: today, endDate: endDate)
    }
    
    public func calendarView(_ calendarView: CalendarView, availabilityStateForDate date: Date) -> AvailabilityState {
        if date < Date().minTimeOfDay() {
            return .unavailable
        }
        return availabilities[date.minTimeOfDay()] != nil ? .available : .unavailable
    }
    
    public func calendarView(_ view: CalendarView, didSelectDate date: Date) {
        guard let availability = availabilities[date.minTimeOfDay()] else {
            Log("No availiability for selected date. There must be one if date was available on the calendar!", data: nil, level: .error)
            return
        }
        selectedOption = nil
        selectedAvailability = availability
    }
    
    public func calendarView(_ view: CalendarView, didChangeMonthWithStartDate startDate: Date, andEndDate endDate: Date) {
        updateCalendarAvailabilities(withStartDate: startDate, endDate: endDate)
    }
    
    private func updateCalendarAvailabilities(withStartDate startDate: Date, endDate: Date) {
        guard let product = product else { return }
        availabilityError = nil
        
        // Don't check availabilities again if already checked for the same dates
        if didAlreadyFetch(forStartDate: startDate, andEndDate: endDate) {
            return
        }
        
        tableView.isUserInteractionEnabled = false
        
        let calendarCell = tableView.cellForRow(at: calendarCellIndexPath) as? CalendarCell
        calendarCell?.calendarView.startLoadingIndicator()
        
        fetchAvailabilities(forProduct: product, from: startDate, to: endDate) { [weak self] (error) in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                self.tableView.isUserInteractionEnabled = true
                let calendarCell = self.tableView.cellForRow(at: self.calendarCellIndexPath) as? CalendarCell
                calendarCell?.calendarView.stopLoadingIndicator(withCalendarRefresh: true)
                
                if error != nil {
                    self.showErrorDialog(withMessage: "Sorry, something went wrong!")
                }
            }
        }
    }
    
    func fetchAvailabilities(forProduct product: Product, from startDate: Date, to endDate: Date, completion: @escaping (_ error: Error?) -> Void) {
        var fetchError: Error?
        
        Traveler.fetchAvailabilities(product: product, startDate: startDate, endDate: endDate) { [weak self] (availabilities, error) in
            if let error = error {
                fetchError = error
            } else if let availabilties = availabilities {
                for availability in availabilties {
                    let date = availability.date.minTimeOfDay()
                    self?.availabilities[date] = availability
                }
            }
            completion(fetchError)
        }
    }
    
    private func showErrorDialog(withMessage message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    private func didAlreadyFetch(forStartDate startDate: Date, andEndDate endDate: Date) -> Bool {
        if availabilities[startDate.minTimeOfDay()] != nil || availabilities[endDate.minTimeOfDay()] != nil {
            return true
        }
        var date = startDate
        repeat {
            if let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: date) {
                date = nextDate
                if availabilities[date.minTimeOfDay()] != nil {
                    return true
                }
            }
        } while date <= endDate
        return false
    }
}

extension AvailabilityViewController: PassFetchDelegate {
    public func passFetchDidSucceedWith(_ result: [Pass]) {
        if let _ = selectedOption {
            optionsViewController?.passFetchDidSucceedWith(result)
            return
        }
        self.passes = result
        performSegue(withIdentifier: "passSegue", sender: nil)
        nextButton.isEnabled = true
    }

    public func passFetchDidFailWith(_ error: Error) {
        if let _ = selectedOption {
            optionsViewController?.passFetchDidFailWith(error)
            return
        }
        nextButton.isEnabled = true
        showErrorDialog(withMessage: error.localizedDescription)
    }
}

extension AvailabilityViewController: BookingOptionsViewControllerDelegate {
    public func bookingOptionsViewController(_ controller: BookingOptionsViewController, didProceedWith option: BookingOption) {
        selectedOption = option
        optionsViewController = controller
        Traveler.fetchPasses(product: product!, availability: selectedAvailability!, option: option, delegate: self)
    }

    public func bookingOptionsViewController(_ controller: BookingOptionsViewController, didFinishWith purchaseForm: PurchaseForm) {
        delegate?.availabilityViewController(self, didFinishWith: purchaseForm)
    }
}

extension AvailabilityViewController: BookingPassesViewControllerDelegate {
    public func bookingPassesViewController(_ controller: BookingPassesViewController, didFinishWith purchaseForm: PurchaseForm) {
        delegate?.availabilityViewController(self, didFinishWith: purchaseForm)
    }
}
