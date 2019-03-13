//
//  PaymentConfirmationViewController.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2019-02-01.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import UIKit
import TravelerKit

class PaymentConfirmationViewController: UIViewController {
    @IBOutlet weak var totalPriceLabel: UILabel!

    var order: Order?

    private var payment: Payment?
    private var paymentHandler: PaymentHandler?
    private var receipt: Receipt?

    override func viewDidLoad() {
        super.viewDidLoad()

        totalPriceLabel.text = order?.total.localizedDescription
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as OrderSummaryViewController):
            vc.order = order
        case (_, let vc as ReceiptViewController):
            vc.receipt = receipt
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    @IBAction func didConfirm(_ sender: Any) {
        guard let paymentProvider = TravelerUI.shared?.paymentProvider else {
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

extension PaymentConfirmationViewController: OrderProcessDelegate {
    func order(_ order: Order, didFailWithError error: Error) {
        ProgressHUD.hide()

        let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }

    func order(_ order: Order, didSucceedWithReceipt receipt: Receipt) {
        ProgressHUD.hide()

        self.receipt = receipt

        performSegue(withIdentifier: "receiptSegue", sender: nil)
    }
}

extension PaymentConfirmationViewController: PaymentHandlerDelegate {
    func paymentHandler(_ handler: PaymentHandler, didCollect payment: Payment) {
        guard let order = order else {
            Log("No Order", data: nil, level: .error)
            return
        }

        self.payment = payment

        ProgressHUD.show()

        Traveler.processOrder(order, payment: payment, delegate: self)
    }
}
