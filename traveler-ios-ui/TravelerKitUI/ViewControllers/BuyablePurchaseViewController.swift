//
//  BuyablePurchaseViewController.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-11-13.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

protocol BuyablePurchaseViewControllerDelegate: class {

}

class BuyablePurchaseViewController: UIViewController {
    weak var delegate: BuyablePurchaseViewControllerDelegate?
}
