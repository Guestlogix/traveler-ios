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
    func bookOptionsViewController(_ controller: BookingOptionsViewController, willProceedWith option: BookingOption)
    func bookOptionsViewController(_ controller: BookingOptionsViewController, didFinishWith bookingForm: BookingForm)
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
        delegate?.bookOptionsViewController(self, willProceedWith: option)
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: optionCellIdentifier, for: indexPath) as! ListCell
        cell.delegate = self
        cell.dataSource = self
        cell.textField.text = selectedOption?.value
        cell.textField.textColor = (optionError != nil ? true : false) ? UIColor.red : UIColor.darkText
        cell.titleLabel.textColor = (optionError != nil ? true : false) ? UIColor.red : UIColor.darkText

        switch (optionError) {
        case .some(BookingError.noOption):
            cell.textField.text = "Please Select"
            cell.textField.textColor = UIColor.red
        default:
            cell.textField.text = selectedOption?.value
        }

        return cell
    }
}

extension BookingOptionsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        optionError = nil
        tableView.reloadRows(at: [indexPath], with: .none)
        tableView.deselectRow(at: indexPath, animated: true)

        let cell = tableView.cellForRow(at: indexPath) as? ListCell
        cell?.textField.becomeFirstResponder()
    }
}

extension BookingOptionsViewController: ListCellDelegate {
    func listCell(_ cell: ListCell, didSelectRow row: Int) {
        selectedOption = availableOptions?[row]
        optionError = nil
        tableView.reloadData()
    }
}

extension BookingOptionsViewController: ListCellDataSource {
    func numberOfRowsInListCell(_ cell: ListCell) -> Int {
        return availableOptions?.count ?? 0
    }

    func listCell(_ cell: ListCell, titleForRow row: Int) -> String? {
        return availableOptions![row].value
    }
}

extension BookingOptionsViewController: BookingPassesViewControllerDelegate {
    func bookingPassesViewController(_ controller: BookingPassesViewController, didFinishWith bookingForm: BookingForm) {
        delegate?.bookOptionsViewController(self, didFinishWith: bookingForm)
    }
}
