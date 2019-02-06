//
//  PurchaseViewController.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-11-12.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

class PurchaseViewController: UIViewController {
    var strategy: PurchaseStrategy?
    var errorContext: ErrorContext?
    var purchaseContext: BookingContext?

    private var order: Order?
    private var payment: Payment?
    private var paymentHandler: PaymentHandler?

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
        case (_, let vc as BuyablePurchaseViewController):
            vc.delegate = self
        case (_, let vc as PaymentConfirmationViewController):
            vc.order = order
            vc.payment = payment
        default:
            Log("Unknown segue", data: nil, level: .warning)
            break
        }
    }
}

extension PurchaseViewController: BookablePurchaseViewControllerDelegate {
    func bookablePurchaseViewController(_ controller: BookablePurchaseViewController, didCreate order: Order) {
        self.order = order

        guard let paymentProvider = PassengerKit.shared?.paymentProvider else {
            fatalError("SDK not initialized")
        }

        let paymentCollectorPackage = paymentProvider.paymentCollectorPackage()
        let vc = paymentCollectorPackage.0
        let paymentHandler = paymentCollectorPackage.1
        let navVC = UINavigationController(rootViewController: vc)

        paymentHandler.delegate = self

        self.paymentHandler = paymentHandler

        present(navVC, animated: true)
    }
}

extension PurchaseViewController: BuyablePurchaseViewControllerDelegate {
    /// This should be similar to above delegate
}

extension PurchaseViewController: PaymentHandlerDelegate {
    func paymentHandler(_ handler: PaymentHandler, didCollect payment: Payment) {
        self.payment = payment
        
        performSegue(withIdentifier: "confirmationSegue", sender: nil)
    }
}
