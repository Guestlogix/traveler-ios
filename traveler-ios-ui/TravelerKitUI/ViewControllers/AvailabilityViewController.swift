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

    private var datePickerCellVisible = false
    private var dateCellIndexPath: IndexPath {
        return IndexPath(row: 0, section: 0)
    }

    private var datePickerCellIndexPath: IndexPath {
        return IndexPath(row: 1, section: 0)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()

        priceLabel.text = product?.price.localizedDescriptionInBaseCurrency
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
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datePickerCellVisible ? 2 : 1
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: dateCellIdentifier, for: indexPath) as! DateCell
            cell.valueLabel.textColor = (availabilityError != nil ? true : false) ? UIColor.red : UIColor.darkText
            cell.titleLabel.textColor = (availabilityError != nil ? true : false) ? UIColor.red : UIColor.darkText

            switch (availabilityError) {
            case .some(BookingError.badDate):
                cell.valueLabel.text = "Unavailable"
            case .some(BookingError.noDate):
                cell.valueLabel.text = "Please Select"
            default:
                cell.valueLabel.text = selectedAvailability.flatMap({ DateFormatter.yearMonthDay.string(from: $0.date) })
            }

            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: datePickerCellIdentifier, for: indexPath) as! DatePickerCell
            cell.datePicker.minimumDate = Date()
            cell.datePicker.date = selectedAvailability?.date ?? Date()
            cell.delegate = self
            return cell
        }
    }
}

extension AvailabilityViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        default:
            break
        }
    }

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == 0 ? 44 : 162
    }
}

extension AvailabilityViewController: DatePickerCellDelegate {
    func datePickerCellValueDidChange(_ cell: DatePickerCell) {
        updateSelectedDate(cell.datePicker.date)
    }

    func updateSelectedDate(_ date: Date) {
        guard let product = product else { return }

        availabilityError = nil

        tableView.isUserInteractionEnabled = false

        Traveler.fetchAvailabilities(product: product, startDate: date, endDate: date, delegate: self)
    }
}

extension AvailabilityViewController: AvailabilitiesFetchDelegate {
    public func availabilitiesFetchDidSucceedWith(_ availabilities: [Availability]) {
        tableView.isUserInteractionEnabled = true

        guard let availability = availabilities.first else {
            availabilityError = BookingError.badDate
            tableView.reloadData()
            return
        }

        selectedOption = nil
        selectedAvailability = availability

        tableView.reloadData()
    }

    public func availabilitiesFetchDidFailWith(_ error: Error) {
        tableView.isUserInteractionEnabled = true

        let alert = UIAlertController(title: "Error", message: "Sorry, something went wrong!", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)

        present(alert, animated: true, completion: nil)
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

        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)

        alert.addAction(okAction)

        present(alert, animated: true)
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
