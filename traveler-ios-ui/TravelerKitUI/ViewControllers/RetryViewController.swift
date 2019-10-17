//
//  ErrorViewController.swift
//  Traveler
//
//  Created by Ata Namvari on 2018-10-17.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import UIKit

public protocol RetryViewControllerDelegate: class {
    func retryViewControllerDidRetry(_ controller: RetryViewController)
}

open class RetryViewController: UIViewController {
    weak var delegate: RetryViewControllerDelegate?

    @IBAction func didRetry(_ sender: UIButton) {
        delegate?.retryViewControllerDidRetry(self)
    }
}
