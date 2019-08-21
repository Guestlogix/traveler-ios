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
    func bookableConfirmationViewControllerDidConfirm(_ controller: BookableConfirmationViewController, with form: BookingForm)
}

class BookableConfirmationViewController: UIViewController {
    var errorContext: ErrorContext?
    var bookingContext: BookingContext?
    weak var delegate: BookableConfirmationViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as BookableAvailabilityViewController):
            vc.bookingContext = bookingContext
            vc.errorContext = errorContext
            vc.delegate = self
        default:
            Log("Unknown Segue", data: segue, level: .warning)
            break
        }
    }
}

extension BookableConfirmationViewController: BookableAvailabilityViewControllerDelegate {
    func bookableAvailabilityViewControllerDidReceiveCheckout(_ controller: BookableAvailabilityViewController, with form: BookingForm) {
        delegate?.bookableConfirmationViewControllerDidConfirm(self, with: form)
    }
}
