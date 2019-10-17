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
    func bookableDetailsViewController(_ controller: BookableDetailsViewController, didUpdate availability: Availability)
    func bookableDetailsViewController(_ controller: BookableDetailsViewController, didSelect option: BookingOption?)
}

let optionCellIdentifier = "optionCellIdentifier"

open class BookableDetailsViewController: UITableViewController {
    var product: Product?
    var selectedAvailability: Availability?
    var availableOptions: [BookingOption]? {
        return selectedAvailability?.optionSet?.options
    }
    var hasOptions: Bool {
        return availableOptions?.count ?? 0 > 0
    }
    var selectedOption: BookingOption?

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

    override open func viewDidLoad() {
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

    override open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (datePickerCellVisible, hasOptions) {
        case (false, false):
            return 1
        case (true, false),
             (false, true):
            return 2
        case (true, true):
            return 3
        }
    }

    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.row, datePickerCellVisible, hasOptions) {
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
                cell.valueLabel.text = selectedAvailability.flatMap({ DateFormatter.yearMonthDay.string(from: $0.date) })
            }

            return cell
        case (1, true, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: datePickerCellIdentifier, for: indexPath) as! DatePickerCell
            cell.datePicker.minimumDate = Date()
            cell.datePicker.date = selectedAvailability?.date ?? Date()
            cell.delegate = self
            return cell
        case (1, false, true),
             (2, true, true):
            let cell = tableView.dequeueReusableCell(withIdentifier: optionCellIdentifier, for: indexPath) as! ListCell
            cell.delegate = self
            cell.dataSource = self
            cell.textField.text = selectedOption?.value
            cell.textField.textColor = (errorContext?.hasAnyOf([.noOption]) ?? false) ? UIColor.red : UIColor.darkText
            cell.titleLabel.textColor = (errorContext?.hasAnyOf([.noOption]) ?? false) ? UIColor.red : UIColor.darkText

            switch (errorContext?.error) {
            case .some(BookingError.noOption):
                cell.textField.text = "Please Select"
                cell.textField.textColor = UIColor.red
            default:
                cell.textField.text = selectedOption?.value
            }

            return cell
        default:
            fatalError("Invalid indexPath")
        }
    }

    // MARK: UITableViewDelegate

    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

            if selectedAvailability == nil {
                updateSelectedDate(Date())

                tableView.reloadRows(at: [indexPath], with: .none)
            }

            updatePreferredContentSize()
        case optionCellIndexPath:
            errorContext?.error = nil
            tableView.reloadRows(at: [indexPath], with: .none)
            tableView.deselectRow(at: indexPath, animated: true)

            let cell = tableView.cellForRow(at: indexPath) as? ListCell
            cell?.textField.becomeFirstResponder()
        default:
            break
        }
    }

    override open func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
        guard let product = product else { return }

        errorContext?.error = nil

        tableView.isUserInteractionEnabled = false

        Traveler.fetchAvailabilities(product: product, startDate: date, endDate: date, delegate: self)
    }
}

extension BookableDetailsViewController: ListCellDelegate {
    func listCell(_ cell: ListCell, didSelectRow row: Int) {
        selectedOption = availableOptions?[row]
        delegate?.bookableDetailsViewController(self, didSelect: selectedOption)
        errorContext?.error = nil
    }
}

extension BookableDetailsViewController: ListCellDataSource {
    func numberOfRowsInListCell(_ cell: ListCell) -> Int {
        return availableOptions?.count ?? 0
    }

    func listCell(_ cell: ListCell, titleForRow row: Int) -> String? {
        return availableOptions![row].value
    }
}

extension BookableDetailsViewController: AvailabilitiesFetchDelegate {
    public func availabilitiesFetchDidSucceedWith(_ availabilities: [Availability]) {
        tableView.isUserInteractionEnabled = true

        guard let availability = availabilities.first else {
            errorContext?.error = BookingError.badDate
            return
        }

        selectedAvailability = availability
        selectedOption = nil
        delegate?.bookableDetailsViewController(self, didUpdate: availability)

        tableView.reloadData()
        updatePreferredContentSize()
    }

    public func availabilitiesFetchDidFailWith(_ error: Error) {
        tableView.isUserInteractionEnabled = true

        let alert = UIAlertController(title: "Error", message: "Sorry, something went wrong!", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }
}

extension BookableDetailsViewController: ErrorContextObserving {
    public func errorContextDidUpdate(_ context: ErrorContext) {
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
