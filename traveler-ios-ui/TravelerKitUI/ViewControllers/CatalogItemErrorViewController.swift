//
//  CatalogItemErrorViewController.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-07.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

protocol CatalogItemErrorViewControllerDelegate: class {
    func catalogItemErrorViewControllerDidRetry(_ controller: CatalogItemErrorViewController)
}

class CatalogItemErrorViewController: UIViewController {
    weak var delegate: CatalogItemErrorViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func didRetry(_ sender: UIButton) {
        delegate?.catalogItemErrorViewControllerDidRetry(self)
    }
}
