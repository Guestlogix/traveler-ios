//
//  FormValueDisplayInputCell.swift
//  TravelerKitUI
//
//  Created by Dorothy Fu on 2019-03-27.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit

class FormValueDisplayInputCell: UICollectionViewCell {
    @IBOutlet weak var valueLabel: UILabel!

    var label: String? {
        didSet {
            update()
        }
    }

    var value: String? {
        didSet {
            update()
        }
    }

    private func update() {
        switch value {
        case .none:
            valueLabel.text = label
            valueLabel.textColor = .lightGray
        case .some(let value):
            valueLabel.text = value
            valueLabel.textColor = .black
        }
    }
}
