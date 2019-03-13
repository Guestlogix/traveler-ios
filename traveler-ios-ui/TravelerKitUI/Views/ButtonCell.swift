//
//  ButtonCell.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-12-10.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

protocol ButtonCellDelegate: class {
    func buttonCellDidPressButton(_ cell: ButtonCell)
}

class ButtonCell: UITableViewCell {
    weak var delegate: ButtonCellDelegate?

    @IBAction func didPress(_ sender: UIButton) {
        delegate?.buttonCellDidPressButton(self)
    }
}
