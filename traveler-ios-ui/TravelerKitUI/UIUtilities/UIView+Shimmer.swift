//
//  UIView+Shimmer.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-05-23.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation

extension UIView {
    func startShimmering(){
        let light = UIColor.white.cgColor
        let alpha = UIColor.white.withAlphaComponent(0.4).cgColor

        let gradient = CAGradientLayer()
        gradient.colors = [light, alpha, light]
        gradient.frame = CGRect(x: -self.bounds.size.width, y: 0, width: 3 * self.bounds.size.width, height: self.bounds.size.height)
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.525)
        gradient.locations = [0.0, 0.2, 0.3]
        self.layer.mask = gradient

        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [0.0, 0.2, 0.3]
        animation.toValue = [0.7, 0.8, 0.9]
        animation.duration = 1.5
        animation.repeatCount = HUGE
        gradient.add(animation, forKey: "shimmer")
    }

    func stopShimmering(){
        self.layer.mask = nil
    }
}
