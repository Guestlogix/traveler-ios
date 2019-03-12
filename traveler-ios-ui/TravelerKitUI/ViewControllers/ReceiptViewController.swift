//
//  ReceiptViewController.swift
//  PassengerKit
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

        titleLabel.text = receipt?.product.title
        dateLabel.text = receipt?.date.flatMap { DateFormatter.longFormatter.string(from: $0) }
        confirmationLabel.text = receipt?.confirmationNumber
        emailLabel.text = receipt?.customerContact.email
    }
}
