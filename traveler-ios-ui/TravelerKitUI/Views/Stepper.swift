//
//  Stepper.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-12-10.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

class Stepper: UIControl {
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var decreaseButton: UIButton!

    @IBInspectable var minimumValue: Int = 0
    @IBInspectable var maximumValue: Int = 5

    @IBInspectable var value: Int = 0 {
        didSet {
            valueLabel.text = String(value)
            updateButtonsEnabledState()
        }
    }

    @IBAction func didIncrease(_ sender: Any) {
        guard value < maximumValue else {
            return
        }

        value += 1;

        increaseButton.isEnabled = value < maximumValue

        sendActions(for: .valueChanged)
    }

    @IBAction func didDecrease(_ sender: Any) {
        guard value > minimumValue else {
            return
        }

        value -= 1;

        sendActions(for: .valueChanged)
    }

    private func updateButtonsEnabledState() {
        increaseButton.isEnabled = value < maximumValue
        decreaseButton.isEnabled = value > minimumValue
    }
}
