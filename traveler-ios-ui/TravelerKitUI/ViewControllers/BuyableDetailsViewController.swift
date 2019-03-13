//
//  BuyableDetailsViewController.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-12-03.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

protocol BuyableDetailsViewControllerDelegate: class {

}

class BuyableDetailsViewController: UIViewController {
    weak var delegate: BuyablePurchaseViewControllerDelegate?
}
