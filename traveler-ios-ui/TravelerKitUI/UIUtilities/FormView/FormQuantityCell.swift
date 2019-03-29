//
//  FormQuantityCell.swift
//  TravelerKitUI
//
//  Created by Dorothy Fu on 2019-03-28.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit

protocol QuantityInputCellDelegate: class {
    func quantityCellValueDidChange(_ cell: FormQuantityInputCell)
}

class FormQuantityInputCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var stepper: Stepper!

    weak var delegate: QuantityInputCellDelegate?

    @IBAction func quantityCellValueDidChange(_ stepper: Stepper) {
        delegate?.quantityCellValueDidChange(self)
    }
}
