//
//  SupplierInfoViewController.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-07-24.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

class SupplierInfoViewController: UIViewController {
    @IBOutlet weak var trademarkCopyLabel: UILabel!
    @IBOutlet weak var trademarkImageView: UIImageView!
    
    var supplier: Supplier?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        trademarkCopyLabel.text = supplier?.trademark?.copyright
        if let imageUrl = supplier?.trademark?.iconUrl {
            AssetManager.shared.loadImage(with: imageUrl) { [weak self] (image)  in
                self?.trademarkImageView.image = image
            }
        }
    }
}
