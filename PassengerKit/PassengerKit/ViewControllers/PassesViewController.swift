//
//  PassesViewController.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-12-10.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

protocol PassesViewControllerDelegate: class {
    func passesViewControllerDidChangePreferredContentSize(_ controller: PassesViewController)
    func passesViewControllerDidChangeQuantities(_ controller: PassesViewController)
}

let stepperCellIdentifier = "stepperCellIdentifier"

class PassesViewController: UITableViewController {
    var passes: [Pass]?
    weak var delegate: PassesViewControllerDelegate?
    var passQuantities = [Pass: Int]()

    override func viewDidLoad() {
        super.viewDidLoad()

        updatePreferredContentSize()
    }

    private func updatePreferredContentSize() {
        tableView.layoutIfNeeded()
        preferredContentSize = tableView.contentSize
        delegate?.passesViewControllerDidChangePreferredContentSize(self)
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passes?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: stepperCellIdentifier, for: indexPath) as! StepperCell
        let pass = passes![indexPath.row]
        cell.titleLabel.text = pass.name
        cell.subTitleLabel.text = pass.description
        cell.stepper.minimumValue = 0
        cell.stepper.maximumValue = pass.maxQuantity ?? 999
        cell.stepper.value = passQuantities[pass] ?? 0
        cell.delegate = self
        return cell
    }
}

extension PassesViewController: StepperCellDelegate {
    func stepperCellValueDidChange(_ cell: StepperCell) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        let pass = passes![indexPath.row]
        passQuantities[pass] = cell.stepper.value

        delegate?.passesViewControllerDidChangeQuantities(self)
    }
}
