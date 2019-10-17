//
//  BuyablePurchaseViewController.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-13.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

public protocol BuyablePurchaseViewControllerDelegate: class {

}

open class BuyablePurchaseViewController: UIViewController {
    weak var delegate: BuyablePurchaseViewControllerDelegate?
}
