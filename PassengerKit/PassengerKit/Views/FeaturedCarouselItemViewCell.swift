//
//  FeaturedCarouselItemViewCell.swift
//  PassengerKit
//
//  Created by Dorothy Fu on 2019-01-17.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import UIKit

open class FeaturedCarouselItemViewCell: UICollectionViewCell {
    @IBOutlet open weak var imageContainerView: UIView!
    @IBOutlet open weak var imageView: UIImageView!
    
    public static var margin: CGFloat {
        return 15
    }
    
    public static var footerHeight: CGFloat {
        return 80
    }
}
