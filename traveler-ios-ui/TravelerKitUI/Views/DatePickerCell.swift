//
//  DatePickerCell.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-13.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

protocol DatePickerCellDelegate: class {
    func datePickerCellValueDidChange(_ cell: DatePickerCell)
}

class DatePickerCell: UITableViewCell {
    @IBOutlet weak var datePicker: UIDatePicker!

    weak var delegate: DatePickerCellDelegate?

    @IBAction func datePickerValueDidChange(_ sender: UIDatePicker) {
        delegate?.datePickerCellValueDidChange(self)
    }
}
