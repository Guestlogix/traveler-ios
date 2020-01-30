//
//  ArrowLeftButton.swift
//  TravelerKitUI
//
//  Created by Josip Petric on 27/01/2020.
//  Copyright © 2020 GuestLogix. All rights reserved.
//

import Foundation

@IBDesignable public class ArrowLeftButton: UIButton {
    @IBInspectable var strokeWidth: CGFloat = 1.5
    @IBInspectable var strokeColor: UIColor?
    
    public override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.3
        }
    }

    override public func draw(_ rect: CGRect) {
        let bezierPath = UIBezierPath(arrowLeftIn: self.bounds)

        if let strokeColor = self.strokeColor {
            strokeColor.setStroke()
        } else {
            self.tintColor.setStroke()
        }

        bezierPath.lineWidth = self.strokeWidth
        bezierPath.stroke()
    }
}
