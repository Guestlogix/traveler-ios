//
//  OrderDetailViewController.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-05-23.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

let orderDetailCellIdentifier = "orderDetailCellIdentifier"
let productCellIdentifier = "productCellIdentifier"
let billingCellIdentifier = "billingCellIdentifier"
let cancelOrderCellIdentifier = "cancelOrderCellIdentifier"

open class OrderDetailViewController: UITableViewController {
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderPriceLabel: UILabel!
    @IBOutlet weak var creditCardLabel: UILabel!
    @IBOutlet weak var emailConfirmation: UIButton!
    @IBOutlet weak var cancellationButton: UIButton!

    var order: Order?

    private var purchasedProduct: PurchasedProduct?
    private var cancellationQuote: CancellationQuote?

    override open func viewDidLoad() {
        super.viewDidLoad()

        loadOrder()
    }

    func loadOrder() {
        guard let order = order else {
            Log("No order", data: nil, level: .error)
            return
        }

        orderNumberLabel.text = order.isCancelled ? "Cancelled: \(order.referenceNumber ?? "")" : order.referenceNumber
        orderDateLabel.text = ISO8601DateFormatter.dateOnlyFormatter.string(from: order.createdDate)
        orderPriceLabel.text = order.total.localizedDescriptionInBaseCurrency
        creditCardLabel.text = "Visa ending in: \(order.paymentDescription ?? "")"
        emailConfirmation.isEnabled = order.canEmailOrderConfirmation
        cancellationButton.isEnabled = !order.isCancelled

        let title = order.isCancelled ? "View cancellation receipt" : "Cancel order"

        cancellationButton.setTitle(title, for: .normal)
    }

    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case ("productDetailSegue", let navVC as UINavigationController):
            let vc = navVC.topViewController as? PurchasedProductDetailViewController
            let query = PurchasedProductDetailsQuery(orderId: order!.id, productId: purchasedProduct!.id, purchaseType: purchasedProduct!.purchaseType)
            vc?.query = query
        case ("cancelSegue", let navVC as UINavigationController):
            let vc = navVC.topViewController as? CancellationViewController
            vc?.quote = cancellationQuote
            vc?.delegate = self
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    // MARK: UITableViewDataSource

    override open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order?.products.count ?? 0
    }

    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let purchasedProduct = order!.products[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: productCellIdentifier, for: indexPath) as! InfoCell
        cell.titleLabel.text = order!.isCancelled ? "Cancelled: \(purchasedProduct.title)" : purchasedProduct.title
        cell.valueLabel.text = purchasedProduct.secondaryDescription
        cell.secondValueLabel?.text = purchasedProduct.finalPrice.localizedDescriptionInBaseCurrency
        
        return cell
    }

    //MARK: UITableViewDelegate

    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        purchasedProduct = order!.products[indexPath.row]

        tableView.deselectRow(at: indexPath, animated: true)

        switch purchasedProduct?.purchaseType {
        case .booking, .parking:
            performSegue(withIdentifier: "productDetailSegue", sender: nil)
        default:
            Log("Details not available for this kind of product", data: nil, level: .warning)
        }
    }

    @IBAction func didCancelOrder(_ sender: Any) {
        ProgressHUD.show()

        guard let order = order else {
            Log("No order", data:  nil, level: .error)
            return
        }

        Traveler.fetchCancellationQuote(order: order, delegate: self)
    }

    @IBAction func didRequestTickets(_ sender: Any) {
        guard let order = order else {
            Log("Missing order", data:  nil, level: .error)
            return
        }

        ProgressHUD.show()

        Traveler.emailOrderConfirmation(order: order, delegate: self)
    }
}

extension OrderDetailViewController: CancellationViewControllerDelegate {
    public func cancellationViewControllerDidExpire(_ controller: CancellationViewController) {
        let alert = UIAlertController(title: "Error", message: "Quote expired", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "", style: .default)
        alert.addAction(okAction)

        present(alert, animated: true, completion:  nil)
        controller.dismiss(animated: true, completion: nil)
    }

    public func cancellationViewController(_ controller: CancellationViewController, didCancel order: Order) {
        controller.dismiss(animated: true, completion: nil)

        self.order = order
        loadOrder()
        tableView.reloadData()
    }
}

extension OrderDetailViewController: CancellationQuoteFetchDelegate {
    public func cancellationQuoteFetchDidSucceedWith(_ quote: CancellationQuote) {
        cancellationQuote = quote

        ProgressHUD.hide()

        performSegue(withIdentifier: "cancelSegue", sender: nil)
    }

    public func cancellationQuoteFetchDidFailWith(_ error: Error) {
        ProgressHUD.hide()

        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)

        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }
}

extension OrderDetailViewController: EmailOrderConfirmationDelegate {
    public func emailDidSucceed() {
        let alert = UIAlertController(title: "Success", message: "Confirmation sent", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)

        alert.addAction(okAction)

        ProgressHUD.hide()

        present(alert, animated: true)
    }

    public func emailDidFailWith(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: "Something went wrong, please try again", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)

        alert.addAction(okAction)

        ProgressHUD.hide()
        
        present(alert, animated: true)
    }
}
