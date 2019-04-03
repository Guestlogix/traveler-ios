//
//  BookableDetailsViewController.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-12-03.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit
import TravelerKit

protocol BookableDetailsViewControllerDelegate: class {
    func bookableDetailsViewControllerDidChangePreferredContentSize(_ controller: BookableDetailsViewController)
}

let optionCellIdentifier = "optionCellIdentifier"

class BookableDetailsViewController: UITableViewController {
    var bookingContext: BookingContext?
    var errorContext: ErrorContext?
    weak var delegate: BookableDetailsViewControllerDelegate?

    private var datePickerCellVisible = false

    private var dateCellIndexPath: IndexPath {
        return IndexPath(row: 0, section: 0)
    }

    private var datePickerCellIndexPath: IndexPath {
        return IndexPath(row: 1, section: 0)
    }

    private var optionCellIndexPath: IndexPath {
        return IndexPath(row: datePickerCellVisible ? 2 : 1, section: 0)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updatePreferredContentSize()

        errorContext?.addObserver(self)
    }

    deinit {
        errorContext?.removeObserver(self)
    }

    private func updatePreferredContentSize() {
        tableView.layoutIfNeeded()
        preferredContentSize = tableView.contentSize
        delegate?.bookableDetailsViewControllerDidChangePreferredContentSize(self)
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (datePickerCellVisible, bookingContext?.hasOptions ?? false) {
        case (false, false):
            return 1
        case (true, false),
             (false, true):
            return 2
        case (true, true):
            return 3
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.row, datePickerCellVisible, bookingContext?.hasOptions ?? false) {
        case (0, _, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: dateCellIdentifier, for: indexPath) as! DateCell
            cell.valueLabel.textColor = (errorContext?.hasAnyOf([.noDate, .badDate]) ?? false) ? UIColor.red : UIColor.darkText
            cell.titleLabel.textColor = (errorContext?.hasAnyOf([.noDate, .badDate]) ?? false) ? UIColor.red : UIColor.darkText

            switch (errorContext?.error) {
            case .some(BookingError.badDate):
                cell.valueLabel.text = "Unavailable"
            case .some(BookingError.noDate):
                cell.valueLabel.text = "Please Select"
            default:
                cell.valueLabel.text = bookingContext?.selectedAvailability.flatMap({ DateFormatter.yearMonthDay.string(from: $0.date) })
            }

            return cell
        case (1, true, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: datePickerCellIdentifier, for: indexPath) as! DatePickerCell
            cell.datePicker.minimumDate = Date()
            cell.datePicker.date = bookingContext?.selectedAvailability?.date ?? Date()
            cell.delegate = self
            return cell
        case (1, false, true),
             (2, true, true):
            let cell = tableView.dequeueReusableCell(withIdentifier: optionCellIdentifier, for: indexPath) as! ListCell
            cell.delegate = self
            cell.dataSource = self
            cell.textField.text = bookingContext?.selectedOption?.value
            cell.titleLabel.textColor = (errorContext?.hasAnyOf([.noOption]) ?? false) ? UIColor.red : UIColor.darkText
            return cell
        default:
            fatalError("Invalid indexPath")
        }
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath {
        case dateCellIndexPath:
            datePickerCellVisible = !datePickerCellVisible

            tableView.beginUpdates()

            if datePickerCellVisible {
                tableView.insertRows(at: [datePickerCellIndexPath], with: .automatic)
            } else {
                tableView.deleteRows(at: [datePickerCellIndexPath], with: .top)
            }

            tableView.endUpdates()

            tableView.deselectRow(at: indexPath, animated: true)

            if bookingContext?.selectedAvailability == nil {
                updateSelectedDate(Date())

                tableView.reloadRows(at: [indexPath], with: .none)
            }

            updatePreferredContentSize()
        case optionCellIndexPath:
            let cell = tableView.cellForRow(at: indexPath) as? ListCell
            cell?.textField.becomeFirstResponder()

            tableView.deselectRow(at: indexPath, animated: true)
        default:
            break
        }
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (indexPath.row, datePickerCellVisible) {
        case (1, true):
            return 162
        default:
            return 44
        }
    }
}

extension BookableDetailsViewController: DatePickerCellDelegate {
    func datePickerCellValueDidChange(_ cell: DatePickerCell) {
        updateSelectedDate(cell.datePicker.date)
    }

    func updateSelectedDate(_ date: Date) {
        guard let bookingContext = bookingContext else { return }

        errorContext?.error = nil

        tableView.isUserInteractionEnabled = false

        Traveler.fetchAvailabilities(product: bookingContext.product, startDate: date, endDate: date, delegate: self)
    }
}

extension BookableDetailsViewController: ListCellDelegate {
    func listCell(_ cell: ListCell, didSelectRow row: Int) {
        bookingContext?.selectedOption = bookingContext?.availableOptions?[row]
        errorContext?.error = nil
    }
}

extension BookableDetailsViewController: ListCellDataSource {
    func numberOfRowsInListCell(_ cell: ListCell) -> Int {
        return bookingContext?.availableOptions?.count ?? 0
    }

    func listCell(_ cell: ListCell, titleForRow row: Int) -> String? {
        return bookingContext!.availableOptions![row].value
    }
}

extension BookableDetailsViewController: AvailabilitiesFetchDelegate {
    func availabilitiesFetchDidSucceedWith(_ availabilities: [Availability]) {
        tableView.isUserInteractionEnabled = true

        guard let availability = availabilities.first else {
            errorContext?.error = BookingError.badDate
            return
        }

        bookingContext?.selectedAvailability = availability

        tableView.reloadData()
        updatePreferredContentSize()
    }

    func availabilitiesFetchDidFailWith(_ error: Error) {
        tableView.isUserInteractionEnabled = true

        let alert = UIAlertController(title: "Error", message: "Sorry, something went wrong!", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }
}

extension BookableDetailsViewController: ErrorContextObserving {
    func errorContextDidUpdate(_ context: ErrorContext) {
        /// https://stackoverflow.com/questions/6409370/uitableview-reloaddata-automatically-calls-resignfirstresponder

        if let _ = context.error {
            tableView.reloadData()
        } else {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
}

extension ErrorContext {
    func hasAnyOf(_ errors: [BookingError]) -> Bool {
        guard let error = error as? BookingError else {
            return false
        }

        return errors.contains(error)
    }
}
