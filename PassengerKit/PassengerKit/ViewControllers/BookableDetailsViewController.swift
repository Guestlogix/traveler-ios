//
//  BookableDetailsViewController.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-12-03.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

enum BookingError: Error {
    case noDate
    case badDate
    case noTime
}

protocol BookableDetailsViewControllerDelegate: class {
    func bookableDetailsViewControllerDidChangePreferredContentSize(_ controller: BookableDetailsViewController)
}


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

    private var timeCellIndexPath: IndexPath {
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
        switch (datePickerCellVisible, bookingContext?.requiresTime ?? false) {
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
        switch (indexPath.row, datePickerCellVisible, bookingContext?.requiresTime ?? false) {
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
                cell.valueLabel.text = bookingContext?.selectedDate.flatMap({ DateFormatter.yearMonthDay.string(from: $0) })
            }

            return cell
        case (1, true, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: datePickerCellIdentifier, for: indexPath) as! DatePickerCell
            cell.datePicker.minimumDate = Date()
            cell.datePicker.date = bookingContext?.selectedDate ?? Date()
            cell.delegate = self
            return cell
        case (1, false, true),
             (2, true, true):
            let cell = tableView.dequeueReusableCell(withIdentifier: timeCellIdentifier, for: indexPath) as! ListCell
            cell.delegate = self
            cell.dataSource = self
            cell.textField.text = bookingContext?.selectedTime?.formattedValue
            cell.titleLabel.textColor = (errorContext?.hasAnyOf([.noTime]) ?? false) ? UIColor.red : UIColor.darkText
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

            if bookingContext?.selectedDate == nil {
                bookingContext?.selectedDate = Date()
                updateSelectedDate(Date())

                tableView.reloadRows(at: [indexPath], with: .none)
            }

            updatePreferredContentSize()
        case timeCellIndexPath:
            let cell = tableView.cellForRow(at: indexPath) as? StringCell
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

        bookingContext.selectedDate = date
        errorContext?.error = nil

        tableView.isUserInteractionEnabled = false

        PassengerKit.checkAvailability(bookingContext: bookingContext, delegate: self)
    }
}

extension BookableDetailsViewController: ListCellDelegate {
    func listCell(_ cell: ListCell, didSelectRow row: Int) {
        bookingContext?.selectedTime = bookingContext?.availableTimes?[row]
        errorContext?.error = nil
    }
}

extension BookableDetailsViewController: ListCellDataSource {
    func numberOfRowsInListCell(_ cell: ListCell) -> Int {
        return bookingContext?.availableTimes?.count ?? 0
    }

    func listCell(_ cell: ListCell, titleForRow row: Int) -> String? {
        return bookingContext!.availableTimes![row].formattedValue
    }
}

extension BookableDetailsViewController: AvailabilityCheckDelegate {
    func availabilityCheckDidFailWith(_ error: Error) {
        tableView.isUserInteractionEnabled = true

        let alert = UIAlertController(title: "Error", message: "Sorry, something went wrong!", preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    func availabilityCheckDidSucceedFor(_ bookingContext: BookingContext) {
        tableView.isUserInteractionEnabled = true

        if bookingContext.hasAvailability {
            tableView.reloadData()
            updatePreferredContentSize()
        } else {
            errorContext?.error = BookingError.badDate
        }
    }
}

extension BookableDetailsViewController: ErrorContextObserving {
    func errorContextDidUpdate(_ context: ErrorContext) {
        tableView.reloadData()
    }
}
