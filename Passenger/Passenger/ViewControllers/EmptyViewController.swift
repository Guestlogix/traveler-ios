//
//  EmptyViewController.swift
//  Passenger
//
//  Created by Ata Namvari on 2018-10-17.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import UIKit

protocol EmptyViewControllerDelegate: class {
    func emptyViewControllerDidTryAgain(_ controller: EmptyViewController)
}

class EmptyViewController: UIViewController  {
    weak var delegate: EmptyViewControllerDelegate?

    @IBAction func didTryAgain(_ sender: UIButton) {
        delegate?.emptyViewControllerDidTryAgain(self)
    }
}
