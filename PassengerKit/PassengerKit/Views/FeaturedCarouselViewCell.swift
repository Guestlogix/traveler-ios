//
//  FeaturedCarouselViewCell.swift
//  PassengerKit
//
//  Created by Dorothy Fu on 2019-02-05.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import UIKit

open class FeaturedCarouselViewCell: CarouselViewCell {
    open override var itemNib: UINib {
        return UINib(nibName: "FeaturedCarouselItemViewCell", bundle: Bundle(for: type(of: self)))
    }
}
