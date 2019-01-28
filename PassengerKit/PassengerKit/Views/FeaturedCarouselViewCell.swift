//
//  CarouselViewCell.swift
//  Passenger
//
//  Created by Ata Namvari on 2018-10-03.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import UIKit


open class FeaturedCarouselViewCell: CarouselViewCell {
    open override var itemNib: UINib {
        return UINib(nibName: "FeaturedCarouselItemViewCell", bundle: Bundle(for: type(of: self)))
    }
}
