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
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var errorMessageToErrorTitleVerticalConstraint: NSLayoutConstraint!
    
    public var errorTitleString: String?
    public var errorMessageString: String?
    public var actionButtonString: String?
    
    public override func viewDidLoad() {
        if delegate == nil {
            actionButton.isHidden = true
            actionButton.isEnabled = false
        } else if let retryButtonString = actionButtonString {
            actionButton.setTitle(retryButtonString, for: .normal)
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
