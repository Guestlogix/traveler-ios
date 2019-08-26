//
//  BookableConfirmationViewController.swift
//  TravelerKitUI
//
//  Created by Ben Ruan on 2019-08-19.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

protocol BookableConfirmationViewControllerDelegate: class {
    func bookableConfirmationViewController(_ controller: BookableConfirmationViewController, didFinishWith bookingForm: BookingForm)
}

class BookableConfirmationViewController: UIViewController {
    var errorContext: ErrorContext?
    var product: Product?
    weak var delegate: BookableConfirmationViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as AvailabilityViewController):
            vc.product = product
            vc.errorContext = errorContext
            vc.delegate = self
        default:
            Log("Unknown Segue", data: segue, level: .warning)
            break
        }
    }
}

extension BookableConfirmationViewController: AvailabilityViewControllerDelegate {
    func availabilityViewController(_ controller: AvailabilityViewController, didFinishWith bookingForm: BookingForm) {
        delegate?.bookableConfirmationViewController(self, didFinishWith: bookingForm)
    }
}
