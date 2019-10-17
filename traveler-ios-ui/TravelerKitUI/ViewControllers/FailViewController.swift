//
//  FailViewController.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-06-25.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit

open class FailViewController: UIViewController {

    var test: Bool?

    override open func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didClose(_ sender: Any) {
        dismiss(animated: true)
    }
}
