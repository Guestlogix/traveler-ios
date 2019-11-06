//
//  ParkingQueryFormViewController.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-10-23.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit
import CoreLocation

let stringCellIdentifier = "stringCellIdentifier"

public protocol ParkingQueryFormViewControllerDelegate: class {
    func parkingQueryFormViewController(_ controller: ParkingQueryFormViewController, didUpdate query: ParkingItemQuery)
}

public class ParkingQueryFormViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    public var query: ParkingItemQuery?
    public weak var delegate: ParkingQueryFormViewControllerDelegate?

    var parkingFilterContext: ParkingFilterContext?
    var locationManager: CLLocationManager?

    private var datePickerTag: Int?
    private let dropOffTag = 0
    private let pickUpTag = 1
    private let nearMe = 0
    private let airport = 1

    public override func viewDidLoad() {
        super.viewDidLoad()
        locationManager?.startUpdatingLocation()
    }

    public override func viewDidAppear(_ animated: Bool) {
        parkingFilterContext?.addObserver(self)
    }

    public override func viewWillDisappear(_ animated: Bool) {
        parkingFilterContext?.removeObserver(self)
    }
}

extension ParkingQueryFormViewController: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return query == nil ? 0 : 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (query!.airportIATA, datePickerTag) {
        case (.none, .none):
            return 2
        case (.none, .some),
             (.some, .none):
            return 3
        case (.some, .some):
            return 4
        }
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (query!.airportIATA, datePickerTag, indexPath.row) {
        case (.some, _, 0):
            // airport code cell
            let cell = tableView.dequeueReusableCell(withIdentifier: stringCellIdentifier, for: indexPath) as! StringCell
            cell.titleLabel?.text = "Airport Code"
            cell.textField.text = query?.airportIATA
            cell.delegate = self
            return cell
        case (.none, _, 0),
             (.some, _, 1):
            // dropOff cell
            let cell = tableView.dequeueReusableCell(withIdentifier: dateCellIdentifier, for: indexPath) as! DateCell
            cell.titleLabel.text = "Drop-off"
            cell.valueLabel.text = DateFormatter.shortDisplayFormatter.string(from: query!.dateRange.lowerBound)
            return cell
        case (.none, .none, 1),
             (.some, .none, 2),
             (.some, .some(dropOffTag), 3),
             (.none, .some(dropOffTag), 2),
             (.some, .some(pickUpTag), 2),
             (_, .some(pickUpTag), 1):
            // pickUp cell
            let cell = tableView.dequeueReusableCell(withIdentifier: dateCellIdentifier, for: indexPath) as! DateCell
            cell.titleLabel.text = "Pickup"
            cell.valueLabel.text = DateFormatter.shortDisplayFormatter.string(from: query!.dateRange.upperBound)
            return cell
        case (.none, .some(dropOffTag), 1),
             (.some, .some(dropOffTag), 2):
            // dropoff date cell
            let cell = tableView.dequeueReusableCell(withIdentifier: datePickerCellIdentifier, for: indexPath) as! DatePickerCell
            cell.datePicker.minimumDate = Date()
            cell.datePicker.date = query!.dateRange.lowerBound
            cell.delegate = self
            cell.tag = dropOffTag
            return cell
        case (.none, .some(pickUpTag), 2),
             (.some, .some(pickUpTag), 3):
             // pickup date cell
             let cell = tableView.dequeueReusableCell(withIdentifier: datePickerCellIdentifier, for: indexPath) as! DatePickerCell
             cell.datePicker.minimumDate = query!.dateRange.lowerBound
             cell.datePicker.date = query!.dateRange.upperBound
             cell.delegate = self
             cell.tag = pickUpTag
             return cell
        default:
            fatalError("Invalid indexPath")
        }
    }

    @IBAction func didUpdate(_ sender: Any) {
        locationManager?.stopUpdatingLocation()

        guard let query = query else {
            return
        }

        delegate?.parkingQueryFormViewController(self, didUpdate: query)
    }
}

extension ParkingQueryFormViewController: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (query!.airportIATA, datePickerTag, indexPath.row) {
        case (.none, .none, 0),
             (.some, .none, 1),
             (.none, .some(pickUpTag), 0),
             (.some, .some(pickUpTag), 1):
            // show dropoff date
            datePickerTag = dropOffTag
        case (.none, .none, 1),
             (.some, .none, 2),
             (.none, .some(dropOffTag), 2),
             (.some, .some(dropOffTag), 3):
            // show pickup date
            datePickerTag = pickUpTag
        default:
            datePickerTag = nil
        }

        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ParkingQueryFormViewController: StringCellDelegate {
    func stringCellValueDidChange(_ cell: StringCell) {
        query?.airportIATA = cell.textField.text?.uppercased()
        query?.boundingBox = nil
    }
}

extension ParkingQueryFormViewController: DatePickerCellDelegate {
    func datePickerCellValueDidChange(_ cell: DatePickerCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        switch cell.tag {
        case dropOffTag:
            query!.dateRange = ClosedRange(uncheckedBounds: (lower: cell.datePicker.date, upper: query!.dateRange.upperBound))
        case pickUpTag:
            query!.dateRange = ClosedRange(uncheckedBounds: (lower: query!.dateRange.lowerBound, upper: cell.datePicker.date))
        default:
            Log("Unknown date cell", data: cell, level: .error)
            break
        }

        let valueIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
        tableView.reloadRows(at: [valueIndexPath], with: .none)
    }
}

extension ParkingQueryFormViewController: ParkingFilterContextObserving {
    public func parkingFilterContextDidChangeSelectedFilter(_ context: ParkingFilterContext) {

        switch context.selectedFilter {
        case nearMe:
            query?.airportIATA = nil
            //TODO: Add input for radius, assuming a 500 m radius for now
            query?.boundingBox = BoundingBox(with: locationManager?.location, radius: 0.5)
        case airport:
            query?.airportIATA = ""
            query?.boundingBox = nil
        default:
            break
        }
        tableView.reloadData()
    }
}
