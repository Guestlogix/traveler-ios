//
//  ErrorViewController.swift
//  Traveler
//
//  Created by Ata Namvari on 2018-10-17.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import UIKit

public protocol ErrorViewControllerDelegate: class {
    func errorViewControllerDidRetry(_ controller: ErrorViewController)
}

open class ErrorViewController: UIViewController {
    public weak var delegate: ErrorViewControllerDelegate?
    
    @IBOutlet weak var errorTitle: UILabel!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var retryButton: UIButton!
    @IBOutlet weak var errorMessageToErrorTitleVerticalConstraint: NSLayoutConstraint!
    
    public var errorTitleString: String?
    public var errorMessageString: String?
    public var retryButtonString: String?
    
    public override func viewDidLoad() {
        if delegate == nil {
            retryButton.isHidden = true
            retryButton.isEnabled = false
        } else if let retryButtonString = retryButtonString {
            retryButton.setTitle(retryButtonString, for: .normal)
        }
        
        if let errorTitleString = errorTitleString {
            errorTitle.text = errorTitleString
        } else {
            errorTitle.isHidden = true
            errorMessageToErrorTitleVerticalConstraint.constant = 0
        }
        
        if let errorMessageString = errorMessageString {
            errorMessage.text = errorMessageString
        }
    }

    @IBAction func didRetry(_ sender: UIButton) {
        delegate?.errorViewControllerDidRetry(self)
    }
}
