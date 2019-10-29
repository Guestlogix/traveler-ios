//
//  CalendarViewController.swift
//  TravelerKitUI
//
//  Created by Ben Ruan on 2019-10-24.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

protocol AvailabilityCalendarViewControllerDelegate: class {
    func availabilityCalendarViewController(_ controller: AvailabilityCalendarViewController, didSelect availability: Availability)
}

class AvailabilityCalendarViewController: UIViewController {
    var representingDate: Date?
    var product: Product?
    var availabilities: [Availability]?
    var delegate: AvailabilityCalendarViewControllerDelegate?

    override open func viewDidLoad() {
        super.viewDidLoad()

        if let _ = availabilities {
            performSegue(withIdentifier: "resultSegue", sender: nil)
        } else {
            reload()
        }
    }

    private func reload() {
        guard let product = product, let date = representingDate else {
            Log("Product or date not found.", data: nil, level: .error)
            return
        }

        guard let monthInterval = Calendar.current.monthInterval(for: date) else {
            Log("Invalid date for month interval.", data: nil, level: .error)
            return
        }

        performSegue(withIdentifier: "loadingSegue", sender: nil)
        Traveler.fetchAvailabilities(product: product, startDate: monthInterval.start, endDate: monthInterval.end, delegate: self)
    }

    // MARK: - Navigation

    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as AvailabilityCalendarResultViewController):
            vc.representingDate = representingDate
            vc.availabilities = availabilities
            vc.delegate = self
        case ("errorSegue", let vc as RetryViewController):
            vc.delegate = self
        case ("loadingSegue", _):
            break
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }
}

extension AvailabilityCalendarViewController: RetryViewControllerDelegate {
    func retryViewControllerDidRetry(_ controller: RetryViewController) {
        reload()
    }
}

extension AvailabilityCalendarViewController: AvailabilitiesFetchDelegate {
    func availabilitiesFetchDidFailWith(_ error: Error) {
        performSegue(withIdentifier: "errorSegue", sender: nil)
    }

    func availabilitiesFetchDidSucceedWith(_ availabilities: [Availability]) {
        self.availabilities = availabilities
        performSegue(withIdentifier: "resultSegue", sender: nil)
    }
}

extension AvailabilityCalendarViewController: AvailabilityCalendarResultViewControllerDelegate {
    func availabilityCalendarResultViewController(_ controller: AvailabilityCalendarResultViewController, didSelect availability: Availability) {
        delegate?.availabilityCalendarViewController(self, didSelect: availability)
    }
}
