//
//  PaymentConfirmationViewController.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-02-01.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import UIKit
import TravelerKit

open class PaymentConfirmationViewController: UIViewController {
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var confirmButton: UIButton!

    var order: Order?

    private var payment: Payment?
    private var receipt: Receipt?
    private var shouldSavePayment: Bool = false

    override open func viewDidLoad() {
        super.viewDidLoad()

        totalPriceLabel.text = order?.total.localizedDescriptionInBaseCurrency
    }

    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination, sender) {
        case (_, let vc as OrderPaymentViewController, _):
            vc.order = order
            vc.delegate = self
        case (_, let vc as ReceiptViewController, _):
            vc.receipt = receipt
        case ("failSegue", let navVC as UINavigationController, let error as Error):
            let vc = navVC.topViewController as? ErrorViewController
            vc?.errorMessageString = error.localizedDescription
            vc?.errorTitleString = "Failed processing order"
            vc?.delegate = self
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

        if let manager = TravelerUI.shared?.paymentManager, shouldSavePayment {
            manager.savePayment(payment) { [unowned self] (error) in
                error.flatMap { Log("Error saving payment", data: $0, level: .warning) }

                Traveler.processOrder(order, payment: payment, delegate: self)
            }
        } else {
            Traveler.processOrder(order, payment: payment, delegate: self)
        }
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
    public func order(_ order: Order, didFailWithError error: Error) {
        ProgressHUD.hide()

        switch error {
        case PaymentError.confirmationRequired(let key, _):
            // TODO: This should be moved out, singleton use should not really go beyond Traveler itself
            // TODO: Should we break the idea of a forced singleton? @Omar
            // PS: There should be way to tag people right in code! Xcode plugin?
            guard let authenticator = TravelerUI.shared?.authenticator else {
                fatalError("SDK not initialized")
            }

            authenticator.delegate = self
            authenticator.authenticate(key, self)
        case PaymentError.processingError:
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)

            present(alert, animated: true, completion: nil)
        default:
            performSegue(withIdentifier: "failSegue", sender: error)
        }
    }

    public func order(_ order: Order, didSucceedWithReceipt receipt: Receipt) {
        ProgressHUD.hide()

        self.receipt = receipt

        performSegue(withIdentifier: "receiptSegue", sender: nil)
    }
}

extension PaymentConfirmationViewController: OrderPaymentViewControllerDelegate {
    public func orderPaymentViewController(_ controller: OrderPaymentViewController, didSelect payment: Payment, saveOption: Bool) {
        self.payment = payment
        self.shouldSavePayment = saveOption
        self.confirmButton.isEnabled = true
    }
}

extension PaymentConfirmationViewController: PaymentAuthenticationDelegate {
    public func paymentAuthenticationDidFailWith(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }

    public func paymentAuthenticationDidSucceed() {
        didConfirm(self)
    }
}

extension PaymentConfirmationViewController: ErrorViewControllerDelegate {
    public func errorViewControllerDidRetry(_ controller: ErrorViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
