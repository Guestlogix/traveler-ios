//
//  PurchaseViewController.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-11-12.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

// TEMP

enum PurchaseDetails {

}

// END TEMP

protocol PurchaseViewControllerDelegate: class {

}

protocol PurchaseViewControllerDataSource: class {
    func purchaseDetailsForPurchaseViewController(_ controller: PurchaseViewController) -> PurchaseDetails?
}

class PurchaseViewController: UIViewController {
    weak var dataSource: PurchaseViewControllerDataSource?
    weak var delegate: PurchaseViewControllerDelegate?
    var strategy: PurchaseStrategy?

    override func viewDidLoad() {
        super.viewDidLoad()

//        switch strategy {
//        case .some(.bookable):
//            performSegue(withIdentifier: "bookableSegue", sender: nil)
//        case .some(.buyable):
//            performSegue(withIdentifier: "buyableSegue", sender: nil)
//        case .none:
//            Log("No Strategy", data: nil, level: .error)
//            break
//        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as BookablePurchaseViewController):
            vc.delegate = self
        case (_, let vc as BuyablePurchaseViewController):
            vc.delegate = self
        default:
            Log("Unknown segue", data: nil, level: .warning)
            break
        }
    }
}

extension PurchaseViewController: BookablePurchaseViewControllerDelegate {

}

extension PurchaseViewController: BuyablePurchaseViewControllerDelegate {

}
