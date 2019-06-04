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

    var order: Order?

    private var product: Product?
    private var resultQuote: CancellationQuote?

    override func viewDidLoad() {
        super.viewDidLoad()

        orderNumberLabel.text = order?.referenceNumber ?? "Order number"
        orderDateLabel.text = DateFormatter.dateOnlyFormatter.string(from: order!.createdDate)
        orderPriceLabel.text = order?.total.localizedDescription
        creditCardLabel.text = "Visa ending in: \(order?.last4Digits ?? "")"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case ("productDetailSegue", let navVC as UINavigationController):
            let vc = navVC.topViewController as? ProductDetailViewController
            vc?.product = product
        case ("cancelQuoteSegue" , let navVC as UINavigationController):
            let vc = navVC.topViewController as? CancelOrderViewController
            vc?.quote = resultQuote
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
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
        cell.productNameLabel.text = product?.title
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
        ProgressHUD.show()
        Traveler.fetchCancellationQuote(order: order!, delegate: self)
    }

    @IBAction func didRequestTickets(_ sender: Any) {

    }
}

extension OrderDetailViewController: CancellationQuoteFetchDelegate {
    func cancellationQuoteFetchDidSucceedWith(_ quote: CancellationQuote) {
        resultQuote = quote

        ProgressHUD.hide()

        performSegue(withIdentifier: "cancelQuoteSegue", sender: nil)
    }

    func cancellationQuoteFetchDidFailWith(_ error: Error) {
        ProgressHUD.hide()

        let alert = UIAlertController(title: "Error", message: "This order is not cancellable", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)

        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }
}
