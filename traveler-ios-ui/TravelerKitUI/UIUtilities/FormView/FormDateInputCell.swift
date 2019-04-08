//
//  FormDateInputCell.swift
//  TravelerKitUI
//
//  Created by Dorothy Fu on 2019-03-27.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit

protocol DateInputCellDelegate: class {
    func dateInputCellValueDidChange(_ cell: FormDateInputCell)
}

class FormDateInputCell: UICollectionViewCell {
    @IBOutlet weak var datePicker: UIDatePicker!

    weak var delegate: DateInputCellDelegate?

    @IBAction func dateValueChanged(_ sender: UIDatePicker) {
        delegate?.dateInputCellValueDidChange(self)
    }
}
