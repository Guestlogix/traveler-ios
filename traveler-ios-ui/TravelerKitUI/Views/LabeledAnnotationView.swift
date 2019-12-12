//
//  LabeledAnnotationView.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-10-21.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import MapKit
import TravelerKit

open class LabeledAnnotationView: MKAnnotationView {
    public var pinHorizontalMargin: CGFloat = 6
    public var pinVerticalMargin: CGFloat = 4
    public var pinArrowHeight: CGFloat = 6
    public var pinBorderWidth: CGFloat = 1.5

    public var isChosen: Bool = false {
        didSet {
            guard let parkingSpot = annotation as? ParkingSpot else {
                Log("MapAnnotation not a ParkingSpot", data: nil, level: .error)
                return
            }

            image = createAnnotationPinImage(withValue: parkingSpot.parkingItem.price.roundedLocalizedDescriptionInBaseCurrency, isChosen: isChosen)
        }
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            isChosen = true
        }
    }

    open func createAnnotationPinImage(withValue value: String?, isChosen: Bool) -> UIImage {
        let textStyle = NSMutableParagraphStyle()
        textStyle.alignment = NSTextAlignment.center
        textStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        var textAttributes = [
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13),
            NSAttributedString.Key.paragraphStyle: textStyle
        ] as [NSAttributedString.Key : Any]

        let valueText = value ?? "No Value"
        let textSize = valueText.size(withAttributes: textAttributes)
        let pinSize = CGSize(width: textSize.width + pinHorizontalMargin * 2, height: textSize.height + pinVerticalMargin * 2 + pinArrowHeight)

        UIGraphicsBeginImageContextWithOptions(pinSize, false, 0.0)

        let pinRect = CGRect(x: 0, y: 0, width: pinSize.width, height: pinSize.height)
        let bezierPath = UIBezierPath(messageBoxIn: pinRect)
        tintColor.setStroke()

        bezierPath.lineWidth = pinBorderWidth
        bezierPath.stroke()

        let textColor: UIColor
        if isChosen {
            tintColor.setFill()
            textColor = UIColor.white
        } else {
            if #available(iOS 13.0, *) {
                UIColor.systemBackground.setFill()
            } else {
                UIColor.white.setFill()
            }
            textColor = tintColor
        }
        bezierPath.fill()

        let valueRect = CGRect(x: pinHorizontalMargin, y: pinVerticalMargin, width: textSize.width, height: textSize.height)
        textAttributes[NSAttributedString.Key.foregroundColor] = textColor
        valueText.draw(in: valueRect, withAttributes: textAttributes)

        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return image!
    }
}
