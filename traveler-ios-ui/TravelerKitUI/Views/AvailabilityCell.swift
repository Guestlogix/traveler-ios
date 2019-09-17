//
//  WishlistCell.swift
//  TravelerKitUI
//
//  Created by Ben Ruan on 2019-09-04.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit

protocol AvailabilityCellDelegate: class {
    func availabilityCellDidPressRemoveButton(_ cell: AvailabilityCell)
}

class AvailabilityCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var availabilityLabel: UILabel!
    @IBOutlet weak var blurryView: UIView!

    var isAvailable: Bool = true {
        didSet {
            blurryView.isHidden = isAvailable
            availabilityLabel.isHidden = isAvailable
        }
    }

    weak var delegate: AvailabilityCellDelegate?

    @IBAction func didPressRemoveButton(_ sender: Any) {
        delegate?.availabilityCellDidPressRemoveButton(self)
    }
}
