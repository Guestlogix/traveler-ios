//
//  ButtonCell.swift
//  Passenger
//
//  Created by Ata Namvari on 2018-10-17.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import UIKit

protocol ButtonCellDelegate: class {
    func buttonCellDidPressButton(_ cell: ButtonCell)
}

class ButtonCell: UITableViewCell {
    @IBOutlet weak var button: UIButton!

    weak var delegate: ButtonCellDelegate?

    @IBAction func didPressButton(_ sender: UIButton) {
        delegate?.buttonCellDidPressButton(self)
    }
}
