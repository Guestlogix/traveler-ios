//
//  UIBezierPath+Shapes.swift
//  TravelerKitUI
//
//  Created by Ben Ruan on 2019-09-16.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation

extension UIBezierPath {
    convenience init(airplane rect: CGRect) {
        self.init()
        
        let minDimension = min(rect.height, rect.width)
        let heightRatio = minDimension / 14
        let widthRatio = minDimension / 15
        
        let heightOffset = rect.height > rect.width ? (rect.height - rect.width) / 2 : 0
        let widthOffset = rect.width > rect.height ? (rect.width - rect.height) / 2 : 0
        
        func scaledCGPoint(x: CGFloat, y: CGFloat) -> CGPoint {
            return CGPoint(x: x * widthRatio + widthOffset, y: y * heightRatio + heightOffset)
        }
        
        self.move(to: scaledCGPoint(x: 4.88, y: 13.61))
        self.addLine(to: scaledCGPoint(x: 6.27, y: 13.61))
        self.addLine(to: scaledCGPoint(x: 9.75, y: 8.04))
        self.addLine(to: scaledCGPoint(x: 13.58, y: 8.04))
        self.addCurve(to: scaledCGPoint(x: 14.62, y: 7), controlPoint1: scaledCGPoint(x: 14.15, y: 8.04), controlPoint2: scaledCGPoint(x: 14.62, y: 7.58))
        self.addCurve(to: scaledCGPoint(x: 13.58, y: 5.96), controlPoint1: scaledCGPoint(x: 14.62, y: 6.42), controlPoint2: scaledCGPoint(x: 14.15, y: 5.96))
        self.addLine(to: scaledCGPoint(x: 9.75, y: 5.96))
        self.addLine(to: scaledCGPoint(x: 6.27, y: 0.39))
        self.addLine(to: scaledCGPoint(x: 4.88, y: 0.39))
        self.addLine(to: scaledCGPoint(x: 6.62, y: 5.96))
        self.addLine(to: scaledCGPoint(x: 2.79, y: 5.96))
        self.addLine(to: scaledCGPoint(x: 1.75, y: 4.57))
        self.addLine(to: scaledCGPoint(x: 0.71, y: 4.57))
        self.addLine(to: scaledCGPoint(x: 1.4, y: 7))
        self.addLine(to: scaledCGPoint(x: 0.71, y: 9.43))
        self.addLine(to: scaledCGPoint(x: 1.75, y: 9.43))
        self.addLine(to: scaledCGPoint(x: 2.79, y: 8.04))
        self.addLine(to: scaledCGPoint(x: 6.62, y: 8.04))
        self.addLine(to: scaledCGPoint(x: 4.88, y: 13.61))
        self.close()
    }
    
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
