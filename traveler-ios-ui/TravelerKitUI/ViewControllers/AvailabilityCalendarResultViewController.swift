//
//  AvailabilityCalendarResultViewController.swift
//  TravelerKitUI
//
//  Created by Ben Ruan on 2019-10-28.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

private let edgeInset = 10
private let cellSpace = 5
let calendarDateCellIdentifier = "calendarDateCellIdentifier"

protocol AvailabilityCalendarResultViewControllerDelegate: class {
    func availabilityCalendarResultViewController(_ controller: AvailabilityCalendarResultViewController, didSelect availability: Availability)
}

class AvailabilityCalendarResultViewController: UICollectionViewController {
    var representingDate: Date?
    var availabilities: [Availability]?
    var delegate: AvailabilityCalendarResultViewControllerDelegate?

    private var numberOfDays: Int?
    private var firstDay: Date?
    private var firstDateIndex: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let date = representingDate else {
            Log("No representing date.", data: nil, level: .error)
            return
        }

        guard let monthInterval = Calendar.current.monthInterval(for: date) else {
            Log("Error getting month interval for representing date.", data: representingDate, level: .error)
            return
        }

        numberOfDays = Calendar.current.numberOfDaysInCorrespondingMonth(for: date)
        firstDay = monthInterval.start
        firstDateIndex = Calendar.current.component(.weekday, from: firstDay!) - 1
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 35
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: calendarDateCellIdentifier, for: indexPath) as! CalendarDateCell

        guard let daysCount = numberOfDays else {
            Log("Unknown error: number of days not found.", data: representingDate, level: .error)
            return cell
        }

        if indexPath.row >= firstDateIndex && indexPath.row < firstDateIndex + daysCount {
            cell.date = Calendar.current.date(byAdding: .day, value: indexPath.row - firstDateIndex, to: firstDay!)
            if let _ = availabilityFor(cell.date) {
                cell.isAvailable = true
            } else {
                cell.isAvailable = false
            }
        }
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let availability = availabilityFor(Calendar.current.date(byAdding: .day, value: indexPath.row - firstDateIndex, to: firstDay!)) {
            delegate?.availabilityCalendarResultViewController(self, didSelect: availability)
        }
    }

    private func availabilityFor(_ date: Date?) -> Availability? {
        guard let date = date, let availabilities = availabilities else {
            return nil
        }

        for availability in availabilities {
            if Calendar.current.compare(availability.date, to: date, toGranularity: .day) == .orderedSame {
                return availability
            }
        }

        return nil
    }
}

extension AvailabilityCalendarResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numOfCellsInRow = 7

        let space = CGFloat(edgeInset * 2 + cellSpace * (numOfCellsInRow - 1))
        let width = (collectionView.frame.size.width - space) / CGFloat(numOfCellsInRow)
        let height = width

        return CGSize(width: width, height: height)
    }
}
