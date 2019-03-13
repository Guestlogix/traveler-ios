//
//  ErrorViewController.swift
//  Traveler
//
//  Created by Ata Namvari on 2018-10-17.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import UIKit

protocol RetryViewControllerDelegate: class {
    func retryViewControllerDidRetry(_ controller: RetryViewController)
}

class RetryViewController: UIViewController {
    weak var delegate: RetryViewControllerDelegate?

    @IBAction func didRetry(_ sender: UIButton) {
        delegate?.retryViewControllerDidRetry(self)
    }
}
