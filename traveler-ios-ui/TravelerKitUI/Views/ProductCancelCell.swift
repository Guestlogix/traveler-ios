//
//  ProductCancelCell.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-06-04.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit

protocol ProductCancelCellDelegate: class {
    func productCancelDidPressButton (_ cell: ProductCancelCell)
}

class ProductCancelCell: UITableViewCell {
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var cancellationFeeLabel: UILabel!
    @IBOutlet weak var refundLabel: UILabel!

    weak var delegate: ProductCancelCellDelegate?

    @IBAction func didPress(_ sender: Any) {
        delegate?.productCancelDidPressButton(self)
    }
}
