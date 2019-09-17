//
//  HeartButton.swift
//  TravelerKitUI
//
//  Created by Ben Ruan on 2019-09-16.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation

@IBDesignable class HeartButton: UIButton {
    @IBInspectable var strokeWidth: CGFloat = 1.5
    @IBInspectable var strokeColor: UIColor?

    override func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath(heartIn: self.bounds)

        if let strokeColor = self.strokeColor {
            strokeColor.setStroke()
        } else {
            self.tintColor.setStroke()
        }

        bezierPath.lineWidth = self.strokeWidth
        bezierPath.stroke()

        if self.isSelected {
            self.tintColor.setFill()
            bezierPath.fill()
        }
    }
}
