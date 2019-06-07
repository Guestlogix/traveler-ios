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

class OrderDetailViewController: UITableViewController {
    @IBOutlet weak var orderNumberLabel: UILabel!
    @IBOutlet weak var orderDateLabel: UILabel!
    @IBOutlet weak var orderPriceLabel: UILabel!
    @IBOutlet weak var creditCardLabel: UILabel!
    @IBOutlet weak var emailTicketsButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!

    var order: Order?

    private var product: Product?
    private var cancellationQuote: CancellationQuote?
    private var prefix:String?

    override func viewDidLoad() {
        super.viewDidLoad()

        reload(with: order?.status)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case ("productDetailSegue", let navVC as UINavigationController):
            let vc = navVC.topViewController as? ProductDetailViewController
            vc?.product = product
        case ("cancelQuoteSegue", let navVC as UINavigationController):
            let vc = navVC.topViewController as? CancellationViewController
            vc?.quote = cancellationQuote
            vc?.delegate = self
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    private func reload(with status:OrderStatus?) {

        if status == OrderStatus.cancelled {
            prefix = "Cancelled: "
            emailTicketsButton.isEnabled = false
            cancelButton.setTitle("View cancellation receipt", for: .normal)
        }

        orderNumberLabel.text = prefix ?? "" + (order?.referenceNumber ?? "Order number")
        orderDateLabel.text = DateFormatter.dateOnlyFormatter.string(from: order!.createdDate)
        orderPriceLabel.text = order?.total.localizedDescription
        creditCardLabel.text = "Visa ending in: \(order?.last4Digits ?? "")"
        tableView.reloadData()
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return order?.products.count ?? 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let product = order?.products[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: productCellIdentifier, for: indexPath) as! ProductCell
        cell.productNameLabel.text = (prefix ?? "") + (product?.title ?? "")
        if let bookableProduct = product as? BookableProduct {
            cell.dateLabel.text = DateFormatter.dateOnlyFormatter.string(from: bookableProduct.eventDate)
            cell.priceLabel.text = bookableProduct.price.localizedDescription
        }
        return cell
    }

    //MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        product = order!.products[indexPath.row]

        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "productDetailSegue", sender: nil)
    }

    @IBAction func didCancelOrder(_ sender: Any) {
        if order?.status != OrderStatus.cancelled {
            ProgressHUD.show()
            Traveler.fetchCancellationQuote(order: order!, delegate: self)
        }
    }

    @IBAction func didRequestTickets(_ sender: Any) {

    }
}

extension OrderDetailViewController: CancellationViewControllerDelegate {
    func cancellationViewController(_ controller: CancellationViewController, cancelationDidFail error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)

        controller.dismiss(animated: true , completion:nil)
    }

    func cancellationViewController(_ controller: CancellationViewController, didCancel order: Order) {
        controller.dismiss(animated: true, completion: nil)
        self.order = order
        reload(with: self.order?.status)
    }
}

extension OrderDetailViewController: CancellationQuoteFetchDelegate {
    func cancellationQuoteFetchDidSucceedWith(_ quote: CancellationQuote) {
        cancellationQuote = quote

        ProgressHUD.hide()

        performSegue(withIdentifier: "cancelSegue", sender: nil)
    }

    func cancellationQuoteFetchDidFailWith(_ error: Error) {
        ProgressHUD.hide()

        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)

        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }
}
