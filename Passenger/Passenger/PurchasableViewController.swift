//
//  PurchasableViewController.swift
//  Passenger
//
//  Created by Ata Namvari on 2018-10-04.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import UIKit
import PassengerKit

class PurchasableViewController: UIViewController {
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var imageView: UIImageView!

    var purchasable: Purchasable?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let imageURL = purchasable?.imageURL else {
            return
        }

        AssetManager.shared.loadImage(with: imageURL) { [weak self] (image) in
            self?.imageView.image = image
        }
    }

    @IBAction func didPressClose() {
        dismiss(animated: true)
    }
}
