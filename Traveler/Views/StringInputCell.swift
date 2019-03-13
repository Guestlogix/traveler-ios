//
//  StringInputCell.swift
//  Traveler
//
//  Created by Ata Namvari on 2018-10-17.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import UIKit

protocol StringInputCellDelegate: class {
    func stringInputCellDidChange(_ cell: StringInputCell)
}

class StringInputCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!

    weak var delegate: StringInputCellDelegate?

    @IBAction func textFieldDidChange(_ sender: UITextField) {
        delegate?.stringInputCellDidChange(self)
    }
}
