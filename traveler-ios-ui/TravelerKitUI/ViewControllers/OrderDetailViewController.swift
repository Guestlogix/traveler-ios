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
    @IBOutlet weak var cancellationButton: UIButton!

    var order: Order?

    private var product: Product?
    private var cancellationQuote: CancellationQuote?

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(orderDidCancel(_:)), name: .orderDidCancel, object: nil)

        loadOrder()
    }

    func loadOrder() {
        orderNumberLabel.text = order?.status == OrderStatus.cancelled ? "Cancelled: \(order?.referenceNumber ?? "")" : order?.referenceNumber
        orderDateLabel.text = DateFormatter.dateOnlyFormatter.string(from: order!.createdDate)
        orderPriceLabel.text = order?.total.localizedDescription
        creditCardLabel.text = "Visa ending in: \(order?.last4Digits ?? "")"

        let title = order?.status == OrderStatus.cancelled ? "View cancellation receipt" : "Cancel order"

        cancellationButton.setTitle(title, for: .normal)

        if let status = order?.status {
            switch status {
            case OrderStatus.cancelled:
                emailTicketsButton.isEnabled = false
                cancellationButton.isEnabled = true
            case OrderStatus.confirmed:
                emailTicketsButton.isEnabled = true
                cancellationButton.isEnabled = true
            case OrderStatus.declined, OrderStatus.pending:
                emailTicketsButton.isEnabled = false
                cancellationButton.isEnabled = false
            case OrderStatus.underReview:
                emailTicketsButton.isEnabled = true
                cancellationButton.isEnabled = false
            }
        }

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case ("productDetailSegue", let navVC as UINavigationController):
            let vc = navVC.topViewController as? ProductDetailViewController
            vc?.product = product
        case ("cancelSegue", let navVC as UINavigationController):
            let vc = navVC.topViewController as? CancellationViewController
            vc?.quote = cancellationQuote
            vc?.delegate = self
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    @objc func orderDidCancel (_ note: Notification) {
        guard let order = note.userInfo?[orderKey] as? Order else {
            Log("Invalid notification", data: note, level: .error)
            return
        }

        self.order = order
        loadOrder()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: productCellIdentifier, for: indexPath) as! InfoCell
        cell.titleLabel.text = order?.status == OrderStatus.cancelled ? "Cancelled: \(product?.title ?? "")" : product?.title
        cell.valueLabel.text = product?.secondaryDescription
        return cell
    }


    //MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        product = order!.products[indexPath.row]

        tableView.deselectRow(at: indexPath, animated: true)
        
        performSegue(withIdentifier: "productDetailSegue", sender: nil)
    }

    @IBAction func didCancelOrder(_ sender: Any) {
        guard let status = order?.status else {
            Log("Order is nil", data: nil, level: .error)
            return
        }

        switch status {
        case OrderStatus.confirmed:
            ProgressHUD.show()
            Traveler.fetchCancellationQuote(order: order!, delegate: self)
        default:
            break
        }
    }

    @IBAction func didRequestTickets(_ sender: Any) {

    }
}

extension OrderDetailViewController: CancellationViewControllerDelegate {
    func cancellationViewController(_ controller: CancellationViewController, didFailWith error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)

        controller.dismiss(animated: true , completion:nil)
    }

    func cancellationViewController(_ controller: CancellationViewController, didCancel order: Order) {
        controller.dismiss(animated: true, completion: nil)
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
