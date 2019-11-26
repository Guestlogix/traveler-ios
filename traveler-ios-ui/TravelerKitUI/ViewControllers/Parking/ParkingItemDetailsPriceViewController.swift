//
//  ParkingItemDetailsPriceViewController.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-10-22.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit

public protocol ParkingItemDetailsPriceViewControllerDelegate: class {
    func parkingItemDetailsPriceViewControllerDidChangePreferredContentSize(_ controller: ParkingItemDetailsPriceViewController)
}

public class ParkingItemDetailsPriceViewController: UIViewController {
    @IBOutlet weak var totalLabel: UILabel!
    // TODO: Attach this and populate the value
    @IBOutlet weak var totalCurrencyLabel: UILabel!
    @IBOutlet weak var dividerView: UIView!
    @IBOutlet weak var payTodayLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var onlinePriceLabel: UILabel!
    @IBOutlet weak var balancePriceLabel: UILabel!
    @IBOutlet weak var noteView: UIView!

    public var details: ParkingItemDetails?
    public weak var delegate: ParkingItemDetailsPriceViewControllerDelegate?

    public override func viewDidLoad() {
        super.viewDidLoad()

        totalLabel.text = details?.price.localizedDescriptionInBaseCurrency
        if details?.price.valueInBaseCurrency == details?.priceToPayOnline.valueInBaseCurrency {
            dividerView.isHidden = true
            payTodayLabel.isHidden = true
            onlinePriceLabel.isHidden = true
            balancePriceLabel.isHidden = true
            balanceLabel.isHidden = true
            noteView.isHidden = true

            preferredContentSize = CGSize(width: view.frame.width, height: 115)
        } else {
            onlinePriceLabel.text = details?.priceToPayOnline.localizedDescriptionInBaseCurrency
            balancePriceLabel.text = details?.priceToPayOnsite.localizedDescriptionInBaseCurrency

            preferredContentSize = CGSize(width: view.frame.width, height: 210)
        }


        delegate?.parkingItemDetailsPriceViewControllerDidChangePreferredContentSize(self)
    }
}
