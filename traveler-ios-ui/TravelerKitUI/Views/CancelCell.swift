//
//  CancelCell.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-05-26.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit

public protocol CancelCellDelegate: class {
    func cancelButtonTapped(_ cell: CancelCell)
}

open class CancelCell: UITableViewCell {

    @IBOutlet weak var cancelButton: UIButton!

    open weak var delegate:CancelCellDelegate?

    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        delegate?.cancelButtonTapped(self)
    }
}
