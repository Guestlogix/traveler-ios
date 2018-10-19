//
//  CarouselItemViewCell.swift
//  Passenger
//
//  Created by Ata Namvari on 2018-10-03.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import UIKit

class CarouselItemViewCell: UICollectionViewCell {
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
}

extension CarouselItemViewCell {
    static var margin: CGFloat {
        return 15
    }

    static var footerHeight: CGFloat {
        return 80
    }
}
