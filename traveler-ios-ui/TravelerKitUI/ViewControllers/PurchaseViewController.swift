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

    var itemDetails: CatalogItemDetails?
    var product: Product?

    private var order: Order?

    override func viewDidLoad() {
        super.viewDidLoad()
        if itemDetails != nil {
            performSegue(withIdentifier: "detailsSegue", sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as PaymentConfirmationViewController):
            vc.order = order
        case (_, let vc as CatalogItemDetailsViewController):
            vc.delegate = self
            vc.itemDetails = itemDetails
            vc.product = product
        default:
            Log("Unknown segue", data: nil, level: .warning)
            break
        }
    }
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

extension PurchaseViewController: CatalogItemDetailsViewControllerDelegate {
    func catalogItemDetailsViewControllerDelegate(_ controller: CatalogItemDetailsViewController, didFinishWith bookingForm: BookingForm) {
        ProgressHUD.show()

        Traveler.createOrder(bookingForm: bookingForm, delegate: self)
    }
}
