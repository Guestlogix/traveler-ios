//
//  PurchaseViewController.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-12.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit
import TravelerKit

class PurchaseViewController: UIViewController {
    var strategy: PurchaseStrategy?
    var errorContext: ErrorContext?
    var purchaseContext: BookingContext?
    var product: Product?

    private var order: Order?

    override func viewDidLoad() {
        super.viewDidLoad()

        switch strategy {
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
        case (_, let vc as BookablePurchaseViewController):
            vc.delegate = self
            vc.bookingContext = purchaseContext
            vc.errorContext = errorContext
            vc.product = product
        case (_, let vc as BuyablePurchaseViewController):
            vc.delegate = self
        case (_, let vc as PaymentConfirmationViewController):
            vc.order = order
        default:
            Log("Unknown segue", data: nil, level: .warning)
            break
        }
    }
}

extension PurchaseViewController: BookablePurchaseViewControllerDelegate {
    func bookablePurchaseViewController(_ controller: BookablePurchaseViewController, didCreate order: Order) {
        self.order = order

        performSegue(withIdentifier: "confirmationSegue", sender: nil)
    }
}

extension PurchaseViewController: BuyablePurchaseViewControllerDelegate {
    /// This should be similar to above delegate
}
