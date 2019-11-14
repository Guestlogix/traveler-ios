//
//  OrderPaymentViewController.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-11-13.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit

public protocol OrderPaymentViewControllerDelegate: class {
    func orderPaymentViewController(_ controller: OrderPaymentViewController, didSelect payment: Payment, saveOption: Bool)
}

public class OrderPaymentViewController: UIViewController {
    public weak var delegate: OrderPaymentViewControllerDelegate?
    public var order: Order?

    private var payments: [Payment]?

    public override func viewDidLoad() {
        super.viewDidLoad()

        reload()
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as OrderSummaryViewController):
            vc.order = order
            vc.delegate = self
            vc.payments = payments ?? []
        case ("loadingSegue", _):
            break
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    private func reload() {
        guard let paymentManager = TravelerUI.shared?.paymentManager else {
            Log("UI SDK not initialized", data: nil, level: .error)
            performSegue(withIdentifier: "errorSegue", sender: nil)
            return
        }

        performSegue(withIdentifier: "loadingSegue", sender: nil)

        paymentManager.fetchPayments(delegate: self)
    }
}

extension OrderPaymentViewController: PaymentsFetchDelegate {
    public func paymentsFetchDidSucceedWith(_ result: [Payment]) {
        self.payments = result

        performSegue(withIdentifier: "resultSegue", sender: nil)
    }

    public func paymentsFetchDidFailWith(_ error: Error) {
        // Graceful:
        // In case of an error fetching saved payment info we still succeed
        // to the next vc
        performSegue(withIdentifier: "resultSegue", sender: nil)

        Log("Error fetching saved payment info", data: error, level: .warning)
    }
}

extension OrderPaymentViewController: OrderSummaryViewControllerDelegate {
    public func orderSummaryViewController(_ controller: OrderSummaryViewController, didSelect payment: Payment, saveOption: Bool) {
        delegate?.orderPaymentViewController(self, didSelect: payment, saveOption: saveOption)
    }
}
