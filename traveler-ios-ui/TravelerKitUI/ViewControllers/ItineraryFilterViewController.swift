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

open class ItineraryFilterViewController: UITableViewController {
    private enum FilterSections: Int, CaseIterable {
        case type
        case dateRange
    }
    
    private let typeCellIdendifier = "TypeCell"
    private let rangeCellIdentifier = "RangeCell"
    private let dateFormat = "dd MMM yyyy"
    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    
    public weak var delegate: ItineraryFilterViewControllerDelegate?
    
    public var dateRange: ClosedRange<Date> = Date().minTimeOfDay() ... Date().maxTimeOfDay()
    public var types = [ItineraryItemType]()
    public var selectedTypes = [ItineraryItemType]()
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: typeCellIdendifier)
        tableView.register(UINib(nibName: "RangeCell", bundle: Bundle(for: ItineraryFilterViewController.self)), forCellReuseIdentifier: rangeCellIdentifier)
        
        startDatePicker.addTarget(self, action: #selector(handleStartDatePicker(sender:)), for: .valueChanged)
        startDatePicker.setDate(dateRange.lowerBound, animated: true)
        startDatePicker.datePickerMode = .date
        startDatePicker.maximumDate = dateRange.upperBound
        
        endDatePicker.addTarget(self, action: #selector(handleEndDatePicker(sender:)), for: .valueChanged)
        endDatePicker.setDate(dateRange.upperBound, animated: true)
        endDatePicker.datePickerMode = .date
        endDatePicker.minimumDate = dateRange.lowerBound
    }
        
    @IBAction func didCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didApply() {
        delegate?.itineraryFilterViewControllerDidApplyFilters(self, types: self.selectedTypes, dateRange: self.dateRange)
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleStartDatePicker(sender: UIDatePicker) {
        let startDate = sender.date
        
        if startDate <= dateRange.upperBound, let cell = tableView.cellForRow(at: IndexPath(row: 0, section: FilterSections.dateRange.rawValue)) as? RangeCell {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            dateRange = startDate...dateRange.upperBound
            startDatePicker.maximumDate = dateRange.upperBound
            endDatePicker.minimumDate = startDate
            cell.startField.text = dateFormatter.string(from: startDate)
        }
    }
    
    @objc func handleEndDatePicker(sender: UIDatePicker) {
        let endDate = sender.date
        
        if endDate >= dateRange.lowerBound, let cell = tableView.cellForRow(at: IndexPath(row: 0, section: FilterSections.dateRange.rawValue)) as? RangeCell {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormat
            dateRange = dateRange.lowerBound...endDate
            startDatePicker.maximumDate = endDate
            endDatePicker.minimumDate = dateRange.lowerBound
            cell.endField.text = dateFormatter.string(from: endDate)
        }
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
            cell.startField.inputView = startDatePicker
            cell.endField.placeholder = "Enter the end date"
            cell.endField.text = dateFormatter.string(from: dateRange.upperBound)
            cell.endField.inputView = endDatePicker
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
}
