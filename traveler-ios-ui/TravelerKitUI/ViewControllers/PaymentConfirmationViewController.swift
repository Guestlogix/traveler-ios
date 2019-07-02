//
//  PaymentConfirmationViewController.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-02-01.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import UIKit
import TravelerKit

class PaymentConfirmationViewController: UIViewController {
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!

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
            vc.delegate = self
        case (_, let vc as ReceiptViewController):
            vc.receipt = receipt
        case ("failSegue", _):
            break
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    @IBAction func didConfirm(_ sender: Any) {
        guard let order = order, let payment = payment else {
            Log("No Order", data: nil, level: .error)
            return
        }

        ProgressHUD.show()

        Traveler.processOrder(order, payment: payment, delegate: self)
    }

    @IBAction func didCancel(_ sender: Any) {
        let alert = UIAlertController(title: "Are you sure you want to cancel?", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Yes", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }

        let cancelAction = UIAlertAction(title: "No", style: .cancel, handler: nil)

        alert.addAction(okAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }
}

extension PaymentConfirmationViewController: OrderProcessDelegate {
    func order(_ order: Order, didFailWithError error: Error) {
        ProgressHUD.hide()

        let alert = UIAlertController(title: "Error", message: "Something went wrong", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { [unowned self] (_) in
            self.performSegue(withIdentifier: "failSegue", sender: nil)
        }
        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }

    func order(_ order: Order, didSucceedWithReceipt receipt: Receipt) {
        ProgressHUD.hide()

        self.receipt = receipt

        performSegue(withIdentifier: "receiptSegue", sender: nil)
    }
}

extension PaymentConfirmationViewController: OrderSummaryViewControllerDelegate {
    func orderSummaryViewController(_ controller: OrderSummaryViewController, didSelect payment: Payment) {
        self.payment = payment
        self.confirmButton.isEnabled = true
    }
}
