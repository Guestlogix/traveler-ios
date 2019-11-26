//
//  UIBezierPath+Shapes.swift
//  TravelerKitUI
//
//  Created by Ben Ruan on 2019-09-16.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation

extension UIBezierPath {
    convenience init(heartIn rect: CGRect) {
        self.init()

        let sideOne = rect.width * 0.4
        let sideTwo = rect.height * 0.3
        let arcRadius = sqrt(sideOne*sideOne + sideTwo*sideTwo)/2

        self.addArc(withCenter: CGPoint(x: rect.width * 0.3, y: rect.height * 0.35), radius: arcRadius, startAngle: 135.degreesToRadians, endAngle: 315.degreesToRadians, clockwise: true)
        self.addLine(to: CGPoint(x: rect.width/2, y: rect.height * 0.2))
        self.addArc(withCenter: CGPoint(x: rect.width * 0.7, y: rect.height * 0.35), radius: arcRadius, startAngle: 225.degreesToRadians, endAngle: 45.degreesToRadians, clockwise: true)
        self.addLine(to: CGPoint(x: rect.width * 0.5, y: rect.height * 0.95))
        self.close()
    }

    convenience init(messageBoxIn rect: CGRect) {
        self.init()

        let bodyHeight: CGFloat = rect.height * 0.8
        let arcRadius: CGFloat = 4
        let arrowHeadWidth: CGFloat = 5
        let margin: CGFloat = 1

        self.addArc(withCenter: CGPoint(x: arcRadius + margin, y: arcRadius + margin), radius: arcRadius, startAngle: 180.degreesToRadians, endAngle: 270.degreesToRadians, clockwise: true)
        self.addLine(to: CGPoint(x: rect.width - arcRadius - margin, y: margin))
        self.addArc(withCenter: CGPoint(x: rect.width - arcRadius - margin, y: arcRadius + margin), radius: arcRadius, startAngle: 270.degreesToRadians, endAngle: 0.degreesToRadians, clockwise: true)
        self.addLine(to: CGPoint(x: rect.width - margin, y: bodyHeight - arcRadius))
        self.addArc(withCenter: CGPoint(x: rect.width - arcRadius - margin, y: bodyHeight - arcRadius), radius: arcRadius, startAngle: 0.degreesToRadians, endAngle: 90.degreesToRadians, clockwise: true)
        self.addLine(to: CGPoint(x: rect.width / 2 + arrowHeadWidth, y: bodyHeight))
        self.addLine(to: CGPoint(x: rect.width / 2, y: rect.height - margin))
        self.addLine(to: CGPoint(x: rect.width / 2 - arrowHeadWidth, y: bodyHeight))
        self.addArc(withCenter: CGPoint(x: arcRadius + margin, y: bodyHeight - arcRadius), radius: arcRadius, startAngle: 90.degreesToRadians, endAngle: 180.degreesToRadians, clockwise: true)

        self.close()
    }
}
