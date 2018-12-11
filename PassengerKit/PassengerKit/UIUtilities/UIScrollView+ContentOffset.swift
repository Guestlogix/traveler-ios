//
//  UIScrollView+ContentOffset.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-12-11.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

extension UIScrollView {
    func setContentOffsetWithoutGoingOver(_ offset: CGPoint, animated: Bool) {
        let maxX = contentSize.width - bounds.width
        let maxY = contentSize.height - bounds.height
        let point = CGPoint(x: min(offset.x, maxX), y: min(offset.y, maxY))

        setContentOffset(point, animated: animated)
    }
}
