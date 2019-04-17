//
//  ButtonTextCell.swift
//  TravelerKitUI
//
//  Created by Dorothy Fu on 2019-04-15.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit

protocol ButtonTextCellDelegate: class {
    func buttonTextCellDidPressButton(_ cell: ButtonTextCell)
}

class ButtonTextCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    weak var delegate: ButtonTextCellDelegate?

    @IBAction func didPress(_ sender: UIButton) {
        delegate?.buttonTextCellDidPressButton(self)
    }
}
