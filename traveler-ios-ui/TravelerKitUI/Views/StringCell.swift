//
//  StringCell.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-13.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

protocol StringCellDelegate: class {
    func stringCellValueDidChange(_ cell: StringCell)
}

class StringCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel?
    @IBOutlet weak var textField: UITextField!

    weak var delegate: StringCellDelegate?

    @IBAction func texdFieldValueDidChange(_ sender: UITextField) {
        delegate?.stringCellValueDidChange(self)
    }
}
