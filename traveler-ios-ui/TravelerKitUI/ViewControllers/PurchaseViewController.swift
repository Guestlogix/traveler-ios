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
   
    var product: BookingItemDetails?

    private var order: Order?

    override func viewDidLoad() {
        super.viewDidLoad()
        performSegue(withIdentifier: "bookableSegue", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as BookablePurchaseViewController):
            vc.delegate = self
            vc.product = product
        case (_, let vc as PaymentConfirmationViewController):
            vc.order = order
        default:
            Log("Unknown segue", data: nil, level: .warning)
            break
        }
    }
}

extension PurchaseViewController: BookablePurchaseViewControllerDelegate {
    func bookablePurchaseViewController(_ controller: BookablePurchaseViewController, didFinishWith bookingForm: BookingForm) {
        ProgressHUD.show()

        Traveler.createOrder(bookingForm: bookingForm, delegate: self)
    }
}

extension PurchaseViewController: BuyablePurchaseViewControllerDelegate {
    /// This should be similar to above delegate
}

extension PurchaseViewController: OrderCreateDelegate {
    func orderCreationDidSucceed(_ order: Order) {
        ProgressHUD.hide()

        self.order = order

        performSegue(withIdentifier: "confirmationSegue", sender: nil)
    }

    func orderCreationDidFail(_ error: Error) {
        ProgressHUD.hide()

        let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)

        present(alert, animated: true)
    }
}
