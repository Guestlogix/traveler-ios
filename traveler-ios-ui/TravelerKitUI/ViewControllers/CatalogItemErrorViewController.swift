//
//  CatalogItemErrorViewController.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-11-07.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

protocol CatalogItemErrorViewControllerDelegate: class {
    func catalogItemErrorViewControllerDidRetry(_ controller: CatalogItemErrorViewController)
}

class CatalogItemErrorViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    var image: UIImage?
    weak var delegate: CatalogItemErrorViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
    }

    @IBAction func didRetry(_ sender: UIButton) {
        delegate?.catalogItemErrorViewControllerDidRetry(self)
    }
}
