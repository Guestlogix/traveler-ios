//
//  ShadowedView.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-12.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

class ShadowedView: UIView {
    @IBInspectable var color: UIColor?

    override func awakeFromNib() {
        self.layer.shadowColor = color?.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        self.layer.shadowOpacity = 0.16
    }
}
