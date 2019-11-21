//
//  ParkingDetailsPriceViewController.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-10-22.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit

public protocol ParkingItemDetailsPriceViewControllerDelegate: class {
    func parkingDetailsPriceViewControllerDidChangePreferredContentSize(_ controller: ParkingDetailsPriceViewController)
}

public class ParkingDetailsPriceViewController: UIViewController {
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var totalTitleLabel: UILabel!
    @IBOutlet weak var onlinePriceLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var balanceView: UIView!
    @IBOutlet weak var noteView: UIView!
    
    public weak var delegate: ParkingItemDetailsPriceViewControllerDelegate?

    public var totalPrice: Price?
    public var onlinePrice: Price?
    public var onsitePrice: Price?

    public override func viewDidLoad() {
        super.viewDidLoad()

        totalLabel.text = totalPrice?.localizedDescriptionInBaseCurrency
        totalTitleLabel.text = "Total Price (\(totalPrice!.baseCurrency.rawValue))"
        
        if onsitePrice?.valueInBaseCurrency == 0 {
            balanceView.isHidden = true
            noteView.isHidden = true
            preferredContentSize = CGSize(width: view.frame.width, height: 115)
        } else {
            onlinePriceLabel.text = onlinePrice?.localizedDescriptionInBaseCurrency
            balanceLabel.text = onsitePrice?.localizedDescriptionInBaseCurrency
            preferredContentSize = CGSize(width: view.frame.width, height: 190)
        }
        
        delegate?.parkingDetailsPriceViewControllerDidChangePreferredContentSize(self)
    }
}
