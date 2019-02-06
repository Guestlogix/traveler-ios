//
//  CarouselItemViewCell.swift
//  Passenger
//
//  Created by Ata Namvari on 2018-10-03.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import UIKit

open class CarouselItemViewCell: UICollectionViewCell {
    @IBOutlet open weak var imageContainerView: UIView!
    @IBOutlet open weak var imageView: UIImageView!
    @IBOutlet open weak var titleLabel: UILabel!
    @IBOutlet open weak var subTitleLabel: UILabel!

    public static var margin: CGFloat {
        return 15
    }

    public static var footerHeight: CGFloat {
        return 80
    }
}
