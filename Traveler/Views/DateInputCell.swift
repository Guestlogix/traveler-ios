//
//  DateInputCell.swift
//  Traveler
//
//  Created by Ata Namvari on 2018-10-17.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import UIKit

protocol DateInputCellDelegate: class {
    func dateInputCellValueDidChange(_ cell: DateInputCell)
}

class DateInputCell: UITableViewCell {
    @IBOutlet weak var datePicker: UIDatePicker!

    weak var delegate: DateInputCellDelegate?

    @IBAction func dateValueChanged(_ sender: UIDatePicker) {
        delegate?.dateInputCellValueDidChange(self)
    }
}
