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
    func bookableAvailabilityViewController(_ controller: BookableAvailabilityViewController, didReceiveCheckoutWith bookingForm: BookingForm)
}

class BookableAvailabilityViewController: UIViewController {
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!

    var errorContext: ErrorContext?
    var product: Product?
    var selectedAvailability: Availability?
    var availableOptions: [BookingOption]? {
        return selectedAvailability?.optionSet?.options
    }
    var selectedOption: BookingOption?

    weak var delegate: BookableAvailabilityViewControllerDelegate?

    /// TEMP

    private var passes: [Pass]?

    /// END TEMP

    override func viewDidLoad() {
        super.viewDidLoad()

        priceLabel.text = product?.price.localizedDescriptionInBaseCurrency
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as BookableDetailsViewController):
            vc.errorContext = errorContext
            vc.product = product
            vc.delegate = self
        case (_, let vc as BookablePassesViewController):
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
            errorContext?.error = BookingError.noDate
            return
        }

        guard availableOptions == nil || selectedOption != nil else {
            errorContext?.error = BookingError.noOption
            return
        }

        nextButton.isEnabled = false

        Traveler.fetchPasses(product: product, availability: availability, option: selectedOption, delegate: self)
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

extension BookableAvailabilityViewController: BookableDetailsViewControllerDelegate {
    func bookableDetailsViewControllerDidChangePreferredContentSize(_ controller: BookableDetailsViewController) {
        return
    }

    func bookableDetailsViewController(_ controller: BookableDetailsViewController, didUpdate availability: Availability) {
        selectedAvailability = availability
        selectedOption = nil
    }

    func bookableDetailsViewController(_ controller: BookableDetailsViewController, didSelect option: BookingOption?) {
        selectedOption = option
    }
}

extension BookableAvailabilityViewController: BookablePassesViewControllerDelegate {
    func bookablePassesViewController(_ controller: BookablePassesViewController, didReceiveCheckoutWith bookingForm: BookingForm) {
        delegate?.bookableAvailabilityViewController(self, didReceiveCheckoutWith: bookingForm)
    }
}
