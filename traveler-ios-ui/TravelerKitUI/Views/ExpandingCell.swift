//
//  ExpandingCell.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-11-28.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit

public protocol ExpandingCellDelegate: class {
    func expandingCellDidChangeContentSize(_ controller: ExpandingCell)
}

open class ExpandingCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var expandLabel: UILabel!

    public weak var delegate: ExpandingCellDelegate?

    public var isExpanded: Bool? {
        didSet {
            descriptionLabel.numberOfLines = self.isExpanded == true ? 0 : 3
            expandLabel.text = self.isExpanded == true ? "Read less" : "Read more"
            delegate?.expandingCellDidChangeContentSize(self)
            self.layoutIfNeeded()
        }
    }
}
