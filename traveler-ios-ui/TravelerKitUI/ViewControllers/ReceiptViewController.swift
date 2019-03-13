//
//  ReceiptViewController.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-02-01.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import UIKit
import TravelerKit

class ReceiptViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!

    var receipt: Receipt?

    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: This VC should account for multiple products

        titleLabel.text = receipt?.order.products.first?.title
        dateLabel.text = receipt.flatMap { DateFormatter.longFormatter.string(from: $0.order.createdDate) }
        confirmationLabel.text = receipt?.order.orderNumber
        //emailLabel.text = receipt?.customerContact.email
    }
}
