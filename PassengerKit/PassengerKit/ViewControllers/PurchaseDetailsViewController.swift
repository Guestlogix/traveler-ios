//
//  PurchaseDetailsViewController.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-11-08.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

protocol PurchaseDetailsViewControllerDelgate: class {
    func purchaseDetailsViewControllerDidChangePreferredContentSize(_ controller: PurchaseDetailsViewController)
}

class PurchaseDetailsViewController: UIViewController {
    weak var delegate: PurchaseDetailsViewControllerDelgate?
    var strategy: PurchaseStrategy?

    override func viewDidLoad() {
        super.viewDidLoad()

//        switch strategy {
//        case .some(.bookable):
//            performSegue(withIdentifier: "availabilitySegue", sender: nil)
//        case .some(.buyable):
//            performSegue(withIdentifier: "quantitySegue", sender: nil)
//        case .none:
//            Log("No Strategy", data: nil, level: .error)
//            break
//        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        switch (segue.identifier, segue.destination) {
//        case (_, let vc as AvailabilityViewController):
//            vc.delegate = self
//        case (_, let vc as QuantityViewController):
//            vc.delegate = self
//        default:
//            Log("Unknown segue", data: segue, level: .warning)
//            break
//        }
    }
}
