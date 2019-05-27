//
//  BillingCell.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-05-23.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit

public protocol BillingCellDelegate: class {
    func emailButtonTapped(_ cell: BillingCell)
}

open class BillingCell: UITableViewCell {

    @IBOutlet weak var creditCardLabel: UILabel!

    open weak var delegate:BillingCellDelegate?

    @IBAction func emailButtonTapped(_ sender: Any) {
        delegate?.emailButtonTapped(self)
    }


}
