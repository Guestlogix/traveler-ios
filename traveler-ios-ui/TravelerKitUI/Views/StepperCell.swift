//
//  StepperCell.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-12-10.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

protocol StepperCellDelegate: class {
    func stepperCellValueDidChange(_ cell: StepperCell)
}

class StepperCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var stepper: Stepper!

    weak var delegate: StepperCellDelegate?

    @IBAction func stepperValueDidChange(_ stepper: Stepper) {
        delegate?.stepperCellValueDidChange(self)
    }
}
