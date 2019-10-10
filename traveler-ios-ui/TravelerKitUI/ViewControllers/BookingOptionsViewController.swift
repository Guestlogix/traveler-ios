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

    var product: BookingItem?
    var selectedAvailability: Availability?
    
    private var passes: [Pass]?
    private var availableOptions: [BookingOption]? {
        return selectedAvailability?.optionSet?.options
    }
    private var optionError: Error?
    private var selectedIndexPath: IndexPath?

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

        guard let indexPath = selectedIndexPath else {
            optionError = BookingError.noOption
            tableView.reloadData()
            return
        }

        nextButton.isEnabled = false
        delegate?.bookingOptionsViewController(self, didProceedWith: availableOptions![indexPath.row])
    }

    func passFetchDidSucceedWith(_ result: [Pass]) {
        nextButton.isEnabled = true
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

extension BookingOptionsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Please select an option"
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return availableOptions?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: optionCellIdentifier, for: indexPath) as! InfoCell
        cell.titleLabel.text = availableOptions![indexPath.row].value
        cell.valueLabel.attributedText = availableOptions![indexPath.row].attributedDisclaimer

        cell.accessoryType = indexPath == selectedIndexPath ? .checkmark : .none

        return cell
    }
}

extension BookingOptionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        optionError = nil

        let previousIndexPath = selectedIndexPath
        selectedIndexPath = indexPath
        tableView.reloadRows(at: [previousIndexPath, selectedIndexPath].compactMap({$0}), with: .automatic)
    }
}

extension BookingOptionsViewController: BookingPassesViewControllerDelegate {
    func bookingPassesViewController(_ controller: BookingPassesViewController, didFinishWith bookingForm: BookingForm) {
        delegate?.bookingOptionsViewController(self, didFinishWith: bookingForm)
    }
}
