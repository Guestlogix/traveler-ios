//
//  AvailabilityFormViewController.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-11-09.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

protocol AvailabilityFormViewControllerDelegate: class {

}

let dateCellIdentifier = "dateCellIdentifier"
let timeCellIdentifier = "timeCellIdentifier"
let datePickerCellIdentifier = "datePickerCellIdentifier"

class AvailabilityFormViewController: UITableViewController {

    var date: Date?
    weak var delegate: AvailabilityFormViewControllerDelegate?

    private var datePickerCellVisible = false

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datePickerCellVisible ? 3 : 2
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch (indexPath.section, indexPath.row, datePickerCellVisible) {
        case (0, 0, _):
            let cell = tableView.dequeueReusableCell(withIdentifier: dateCellIdentifier, for: indexPath) as! DateCell
            //cell.valueLabel.text =
            return cell
        default:
            fatalError("Something went wrong")
        }
    }

    // MARK: UITableViewDelegate
}
