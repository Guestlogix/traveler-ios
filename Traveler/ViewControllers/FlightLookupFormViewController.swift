//
//  FlightSearchFormViewController.swift
//  Traveler
//
//  Created by Ata Namvari on 2018-10-17.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import UIKit

protocol FlightLookupFormViewControllerDelegate: class {
    func flightLookupFormViewControllerDidSubmit(_ controller: FlightLookupFormViewController)
}

let stringInputCellIdentifier = "stringInputCellIdentifier"
let valueDisplayCellIdentifier = "valueDisplayCellIdentifier"
let dateInputCellIdentifier = "dateInputCellIdentifier"
let buttonCellIdentifier = "buttonCellIdentifier"

class FlightLookupFormViewController: UITableViewController {
    weak var delegate: FlightLookupFormViewControllerDelegate?

    var flightNumber: String?
    var flightDate: Date?

    private let flightNumberRegex = try? NSRegularExpression(pattern: "^([A-Z]{2}|[A-Z]\\d|\\d[A-Z])([1-9][0-9]{0,3}|[0-9]{0,3}[1-9])$", options: .caseInsensitive)
    private var flightNumberValid = true
    private var datePickerCellVisible = false
    private var buttonCellIndexPath: IndexPath {
        return IndexPath(row: datePickerCellVisible ? 3 : 2, section: 0)
    }

    private var flightDateValueDisplayCellIndexPath: IndexPath {
        return IndexPath(row: 1, section: 0)
    }

    private var dateCellIndexPath: IndexPath {
        return IndexPath(row: 2, section: 0)
    }

    private var flightNumberCellIndexPath: IndexPath {
        return IndexPath(row: 0, section: 0)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datePickerCellVisible ? 4 : 3
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.row, datePickerCellVisible, flightNumberValid) {
        case (2, true, _):
            return 215
        case (0, _, false):
            return 80
        default:
            return 44
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.row, datePickerCellVisible) {
        case (0, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: stringInputCellIdentifier, for: indexPath) as! StringInputCell
            cell.label.text = "Flight Number"
            cell.textField.text = flightNumber
            cell.delegate = self
            cell.errorLabel.text = "Flight number must be of the form XX1230"
            cell.errorLabel.isHidden = flightNumberValid
            return cell
        case (1, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: valueDisplayCellIdentifier, for: indexPath) as! ValueDisplayInputCell
            cell.label.text = "Departure Date"
            cell.valueLabel.text = flightDate.flatMap({ DateFormatter.abbrMonthDayYear.string(from: $0) })
            return cell
        case (2, true):
            let cell = tableView.dequeueReusableCell(withIdentifier: dateInputCellIdentifier, for: indexPath) as! DateInputCell
            cell.datePicker.date = flightDate ?? Date()
            cell.datePicker.minimumDate = Date()
            cell.delegate = self
            return cell
        case (2, false),
             (3, true):
            let cell = tableView.dequeueReusableCell(withIdentifier: buttonCellIdentifier, for: indexPath) as! ButtonCell
            cell.button.setTitle("Search Flights", for: .normal)
            cell.button.isEnabled = flightNumber != nil && flightDate != nil
            cell.delegate = self
            return cell
        default:
            fatalError("Invalid indexPath")
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath == flightDateValueDisplayCellIndexPath else { return }

        datePickerCellVisible = !datePickerCellVisible

        tableView.beginUpdates()

        if datePickerCellVisible {
            tableView.insertRows(at: [dateCellIndexPath], with: .automatic)
        } else {
            tableView.deleteRows(at: [dateCellIndexPath], with: .top)
        }

        tableView.endUpdates()

        tableView.deselectRow(at: indexPath, animated: true)

        if flightDate == nil {
            flightDate = Date()
            tableView.reloadRows(at: [indexPath], with: .none)
        }

        tableView.reloadRows(at: [buttonCellIndexPath], with: .none)

        view.endEditing(true)
    }
}

extension FlightLookupFormViewController: StringInputCellDelegate {
    func stringInputCellDidChange(_ cell: StringInputCell) {
        flightNumber = cell.textField.text

        tableView.reloadRows(at: [buttonCellIndexPath], with: .none)
    }
}

extension FlightLookupFormViewController: DateInputCellDelegate {
    func dateInputCellValueDidChange(_ cell: DateInputCell) {
        flightDate = cell.datePicker.date

        tableView.reloadRows(at: [flightDateValueDisplayCellIndexPath, buttonCellIndexPath], with: .none)
    }
}

extension FlightLookupFormViewController: ButtonCellDelegate {
    func buttonCellDidPressButton(_ cell: ButtonCell) {
        defer {
            tableView.reloadRows(at: [flightNumberCellIndexPath], with: .none)
        }

        guard let regex = flightNumberRegex, regex.numberOfMatches(in: flightNumber!, options: [], range: NSRange(location: 0, length: flightNumber!.count)) > 0 else {

            flightNumberValid = false
            return
        }

        flightNumberValid = true

        delegate?.flightLookupFormViewControllerDidSubmit(self)
    }
}
