//
//  BookableAvailabilityViewController.swift
//  TravelerKitUI
//
//  Created by Ben Ruan on 2019-08-14.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

protocol BookableAvailabilityViewControllerDelegate: class {
    func bookableAvailabilityViewControllerDidConfirm(_ controller: BookableAvailabilityViewController, bookingForm: BookingForm)
}

class BookableAvailabilityViewController: UIViewController {
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!

    var errorContext: ErrorContext?
    var bookingContext: BookingContext?
    weak var delegate: BookableAvailabilityViewControllerDelegate?

    /// TEMP

    private var passes: [Pass]?

    /// END TEMP

    override func viewDidLoad() {
        super.viewDidLoad()

        bookingContext?.addObserver(self)
        priceLabel.text = bookingContext?.product.price.localizedDescriptionInBaseCurrency
    }

    deinit {
        bookingContext?.removeObserver(self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as BookableDetailsViewController):
            vc.errorContext = errorContext
            vc.bookingContext = bookingContext
        case (_, let vc as BookableConfirmationViewController):
            vc.passes = passes
            vc.product = bookingContext?.product
            vc.delegate = self
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    @IBAction func didProceed(_ sender: Any) {
        guard let bookingContext = bookingContext else {
            Log("No BookingContext", data: nil, level: .error)
            return
        }

        guard let availability = bookingContext.selectedAvailability else {
            errorContext?.error = BookingError.noDate
            return
        }

        guard bookingContext.availableOptions == nil || bookingContext.selectedOption != nil else {
            errorContext?.error = BookingError.noOption
            return
        }

        nextButton.isEnabled = false

        Traveler.fetchPasses(product: bookingContext.product, availability: availability, option: bookingContext.selectedOption, delegate: self)
    }
}

extension BookableAvailabilityViewController: PassFetchDelegate {
    func passFetchDidSucceedWith(_ result: [Pass]) {
        self.passes = result

        performSegue(withIdentifier: "passSegue", sender: nil)

        nextButton.isEnabled = true
    }

    func passFetchDidFailWith(_ error: Error) {
        nextButton.isEnabled = true
        errorContext?.error = error
    }
}

extension BookableAvailabilityViewController: BookingContextObserving {
    func bookingContextDidUpdate(_ context: BookingContext) {
        nextButton.isEnabled = context.isReady
    }
}

extension BookableAvailabilityViewController: BookableConfirmationViewControllerDelegate {
    func bookableConfirmationViewControllerDidConfirm(_ controller: BookableConfirmationViewController, bookingForm: BookingForm) {
        delegate?.bookableAvailabilityViewControllerDidConfirm(self, bookingForm: bookingForm)
    }
}
