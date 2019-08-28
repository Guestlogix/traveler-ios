//
//  BookingOptionsViewController.swift
//  TravelerKitUI
//
//  Created by Ben Ruan on 2019-08-26.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

protocol BookingOptionsViewControllerDelegate: class {
    func bookingOptionsViewController(_ controller: BookingOptionsViewController, didProceedWith option: BookingOption)
    func bookingOptionsViewController(_ controller: BookingOptionsViewController, didFinishWith bookingForm: BookingForm)
}

class BookingOptionsViewController: UIViewController {
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    weak var delegate: BookingOptionsViewControllerDelegate?

    var product: Product?
    var selectedAvailability: Availability?
    var availableOptions: [BookingOption]? {
        return selectedAvailability?.optionSet?.options
    }
    var optionError: Error?
    var selectedOption: BookingOption?

    var passes: [Pass]?

    override func viewDidLoad() {
        super.viewDidLoad()

        priceLabel.text = product?.price.localizedDescriptionInBaseCurrency
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.destination {
        case let vc as BookingPassesViewController:
            vc.passes = passes
            vc.product = product
            vc.delegate = self
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    @IBAction func didProceed(_ sender: Any) {
        guard let _ = product else {
            Log("No product", data: nil, level: .error)
            return
        }

        guard let option = selectedOption else {
            optionError = BookingError.noOption
            tableView.reloadData()
            return
        }

        nextButton.isEnabled = false
        delegate?.bookingOptionsViewController(self, didProceedWith: option)
    }

    func passFetchDidSucceedWith(_ result: [Pass]) {
        passes = result
        performSegue(withIdentifier: "optionPassSegue", sender: nil)
    }

    func passFetchDidFailWith(_ error: Error) {
        nextButton.isEnabled = true

        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)

        alert.addAction(okAction)

        present(alert, animated: true)
    }
}

extension BookingOptionsViewController: BookingPassesViewControllerDelegate {
    func bookingPassesViewController(_ controller: BookingPassesViewController, didFinishWith bookingForm: BookingForm) {
        delegate?.bookingOptionsViewController(self, didFinishWith: bookingForm)
    }
}
