//
//  LoadingViewController.swift
//  TravelerKitUI
//
//  Created by Rakin Hoque on 2019-11-08.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit

open class LoadingViewController: UIViewController {
    @IBOutlet weak var loadingTitle: UILabel!
    
    public var loadingTitleString: String?
    
    public override func viewDidLoad() {
        if let loadingTitleString = loadingTitleString {
            loadingTitle.text = loadingTitleString
        }
    }
}
