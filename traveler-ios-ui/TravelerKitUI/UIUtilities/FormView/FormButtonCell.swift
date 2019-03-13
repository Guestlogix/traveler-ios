//
//  FormButtonCell.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-01-21.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import UIKit

protocol FormButtonCellDelegate: class {
    func buttonCellDidPressButton(_ cell: FormButtonCell)
}

class FormButtonCell: UICollectionViewCell {
    @IBOutlet weak var button: UIButton!

    weak var delegate: FormButtonCellDelegate?

    @IBAction func didPressButton(_ sender: Any) {
        delegate?.buttonCellDidPressButton(self)
    }
}

