//
//  ImageFormatter.swift
//  Traveler
//
//  Created by Dorothy Fu on 2019-03-20.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit

extension UIImageView {
    func setRoundImage() {
        self.layer.borderWidth=1.0
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.size.height/2
        self.clipsToBounds = true
    }
}
