//
//  OrderSummaryViewController.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-02-01.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import UIKit
import TravelerKit

/// This view controller will potentially have embedded view controllers inside to support different type of orders

let orderItemCellIdentifier = "orderItemCellIdentifier"
let infoCellIdentifier = "infoCellIdentifier"
let headerViewIdentifier = "headerViewIdentifier"

protocol OrderSummaryViewControllerDelegate: class {
    func orderSummaryViewController(_ controller: OrderSummaryViewController, didSelect payment: Payment)
}

class OrderSummaryViewController: UITableViewController {
    var order: Order?
    weak var delegate: OrderSummaryViewControllerDelegate?

    // TODO: Pull list of saved payment methods from PaymentSDK
    private var payments: [Payment] = []
    private var selectedPaymentIndex: Int? {
        didSet {
            selectedPaymentIndex.flatMap {
                delegate?.orderSummaryViewController(self, didSelect: payments[$0])
            }
        }
    }
    private var paymentHandler: PaymentHandler?
    private var billingSection: Int {
        return order?.products.count ?? 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let bundle = Bundle(for: HeaderView.self)
        tableView.register(UINib(nibName: "HeaderView", bundle: bundle), forHeaderFooterViewReuseIdentifier: headerViewIdentifier)
    }

    // MARK: UITableViewDataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        return (order?.products.count ?? 0) + 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case billingSection:
            return payments.count + 1
        default:
            return (order!.products[section] as? BookableProduct)?.passes.count ?? 1
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case billingSection where indexPath.row < payments.count:
            let cell = tableView.dequeueReusableCell(withIdentifier: "infoCellIdentifier", for: indexPath) as! InfoCell
            cell.titleLabel.text = payments[indexPath.row].localizedDescription
            cell.accessoryType = indexPath.row == selectedPaymentIndex ? .checkmark : .none
            return cell
        case billingSection:
            let cell = tableView.dequeueReusableCell(withIdentifier: "addCellIdentifier", for: indexPath) as! InfoCell
            cell.titleLabel.text = "Add card"
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: orderItemCellIdentifier, for: indexPath) as! OrderItemViewCell
            let pass = (order!.products.first as? BookableProduct)?.passes[indexPath.row]
            cell.titleLabel.text = pass?.name
            cell.subTitleLabel.text = pass?.description
            cell.priceLabel.text = pass?.price.localizedDescription
            return cell
        }
    }

    // MARK: UITableViewDelegate

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case billingSection:
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerViewIdentifier) as! HeaderView
            headerView.titleLabel.text = "Billing Information"
            headerView.disclaimerLabel.text = nil
            return headerView
        default:
            let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: headerViewIdentifier) as! HeaderView
            headerView.titleLabel.text = order?.products[section].title
            headerView.disclaimerLabel.text = nil // TODO: Add something associated with the product, in case of a bookable it should be the booking date, sent back from the server
            return headerView
        }
    }

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case billingSection:
            return HeaderView.boundingSize(with: tableView.bounds.size, title: "Billing Information", disclaimer: nil).height
        default:
            // TODO: It goes here as well ^
            return HeaderView.boundingSize(with: tableView.bounds.size, title: order?.products[section].title, disclaimer: nil).height
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (billingSection, payments.count):
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
        case (billingSection, _) where selectedPaymentIndex != indexPath.row:
            selectedPaymentIndex = indexPath.row
            tableView.reloadSections(IndexSet([billingSection]), with: .none)
        default:
            break
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        switch tableView.cellForRow(at: indexPath)?.reuseIdentifier{
        case infoCellIdentifier?:
            return true
        default:
            return false
        }
    }

    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Remove") { (action, indexPath) in
            self.payments.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return [deleteAction]
    }
}

extension OrderSummaryViewController: PaymentHandlerDelegate {
    func paymentHandler(_ handler: PaymentHandler, didCollect payment: Payment) {
        guard !payments.contains(where:  { $0.securePayload() == payment.securePayload() }) else {
            return
        }

        payments.insert(payment, at: 0)
        selectedPaymentIndex = 0

        tableView.reloadData()
    }
}
