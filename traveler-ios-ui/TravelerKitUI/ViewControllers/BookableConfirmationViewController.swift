//
//  BookingConfirmationViewController.swift
//  TravelerKitUI
//
//  Created by Ben Ruan on 2019-08-19.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

protocol BookingConfirmationViewControllerDelegate: class {
    func bookingConfirmationViewController(_ controller: BookingConfirmationViewController, didFinishWith bookingForm: BookingForm)
}

class BookingConfirmationViewController: UIViewController {
    var product: Product?
    weak var delegate: BookingConfirmationViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as AvailabilityViewController):
            vc.product = product
            vc.delegate = self
        default:
            Log("Unknown Segue", data: segue, level: .warning)
            break
        }
    }
}

extension BookingConfirmationViewController: AvailabilityViewControllerDelegate {
    func availabilityViewController(_ controller: AvailabilityViewController, didFinishWith bookingForm: BookingForm) {
        delegate?.bookingConfirmationViewController(self, didFinishWith: bookingForm)
    }
}
