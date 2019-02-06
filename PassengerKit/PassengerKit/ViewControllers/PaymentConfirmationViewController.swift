//
//  PaymentConfirmationViewController.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2019-02-01.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import UIKit

class PaymentConfirmationViewController: UIViewController {
    @IBOutlet weak var totalPriceLabel: UILabel!

    var order: Order?
    var payment: Payment?

    private var receipt: Receipt?

    override func viewDidLoad() {
        super.viewDidLoad()

        totalPriceLabel.text = order?.total.localizedDescription
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as OrderSummaryViewController):
            vc.order = order as? BookingOrder
        case (_, let vc as ReceiptViewController):
            vc.receipt = receipt
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    @IBAction func didConfirm(_ sender: Any) {
        guard let order = order, let payment = payment else {
            Log("No Order/Payment", data: nil, level: .error)
            return
        }

        ProgressHUD.show()

        PassengerKit.processOrder(order, payment: payment, delegate: self)
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
