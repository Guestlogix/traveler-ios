//
//  WishlistCell.swift
//  TravelerKitUI
//
//  Created by Ben Ruan on 2019-09-04.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit

protocol WishlistCellDelegate: class {
    func wishlistCellDidPressRemoveButton(_ cell: WishlistCell)
}

class WishlistCell: UICollectionViewCell {
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!

    weak var delegate: WishlistCellDelegate?

    @IBAction func didPressRemoveButton(_ sender: Any) {
        delegate?.wishlistCellDidPressRemoveButton(self)
    }
}
