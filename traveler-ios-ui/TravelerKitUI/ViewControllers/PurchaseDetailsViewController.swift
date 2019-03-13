//
//  PurchaseDetailsViewController.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-08.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit
import TravelerKit

protocol PurchaseDetailsViewControllerDelgate: class {
    func purchaseDetailsViewControllerDidChangePreferredContentSize(_ controller: PurchaseDetailsViewController)
}

class PurchaseDetailsViewController: UIViewController {
    weak var delegate: PurchaseDetailsViewControllerDelgate?
    var catalogItemDetails: CatalogItemDetails?
    var errorContext: ErrorContext?
    var purchaseContext: BookingContext?

    override func viewDidLoad() {
        super.viewDidLoad()

        switch catalogItemDetails?.purchaseStrategy {
        case .some(.bookable):
            performSegue(withIdentifier: "bookableSegue", sender: nil)
        case .some(.buyable):
            performSegue(withIdentifier: "buyableSegue", sender: nil)
        case .none:
            Log("No Strategy", data: nil, level: .error)
            break
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as BookableDetailsViewController):
            vc.delegate = self
            vc.errorContext = errorContext
            vc.bookingContext = purchaseContext
        case (_, let vc as BuyableDetailsViewController):
            vc.delegate = self
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }
}

extension PurchaseDetailsViewController: BookableDetailsViewControllerDelegate {
    func bookableDetailsViewControllerDidChangePreferredContentSize(_ controller: BookableDetailsViewController) {
        preferredContentSize = controller.preferredContentSize
        delegate?.purchaseDetailsViewControllerDidChangePreferredContentSize(self)
    }
}

extension PurchaseDetailsViewController: BuyablePurchaseViewControllerDelegate {

}
