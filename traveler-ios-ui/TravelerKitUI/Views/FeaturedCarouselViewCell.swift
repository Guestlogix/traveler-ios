//
//  FeaturedCarouselViewCell.swift
//  TravelerKitUI
//
//  Created by Dorothy Fu on 2019-02-13.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit

open class FeaturedCarouselViewCell: CarouselViewCell {
    open override var itemNib: UINib {
        return UINib(nibName: "FeaturedCarouselItemViewCell", bundle: Bundle(for: type(of: self)))
    }
}
