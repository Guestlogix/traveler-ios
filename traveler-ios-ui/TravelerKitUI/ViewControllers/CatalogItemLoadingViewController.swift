//
//  CatalogItemLoadingViewController.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-07.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

class CatalogItemLoadingViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!

    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()

        imageView.image = image
    }
}
