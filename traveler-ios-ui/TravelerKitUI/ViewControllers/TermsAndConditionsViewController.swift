//
//  TermsAndConditionsViewController.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-07-26.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit

open class TermsAndConditionsViewController: UIViewController {
    @IBOutlet weak var termsAndConditionsLabel: UILabel!

    var termsAndConditions: NSMutableAttributedString?

    override public func viewDidLoad() {
        super.viewDidLoad()

        termsAndConditions?.setFontFace(font: UIFont.systemFont(ofSize: 17))
        termsAndConditionsLabel.attributedText = termsAndConditions
    }

    @IBAction func didClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
