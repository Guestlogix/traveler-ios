//
//  ShadowedView.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-11-12.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

class ShadowedView: UIView {
    override func awakeFromNib() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: -1)
        self.layer.shadowRadius = 1
        self.layer.shadowOpacity = 0.1
    }
}
