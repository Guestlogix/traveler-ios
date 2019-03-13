//
//  InputCell.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-12-17.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

protocol StringInputCellDelegate: class {
    func stringInputCellValueDidChange(_ cell: FormStringInputCell)
}

class FormStringInputCell: UICollectionViewCell {
    @IBOutlet weak var textField: UITextField!

    weak var delegate: StringInputCellDelegate?

    @IBAction func textFieldValueDidChange(_ textField: UITextField) {
        delegate?.stringInputCellValueDidChange(self)
    }
}
