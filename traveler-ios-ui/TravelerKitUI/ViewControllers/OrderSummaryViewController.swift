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

public protocol OrderSummaryViewControllerDelegate: class {
    func orderSummaryViewController(_ controller: OrderSummaryViewController, didSelect payment: Payment)
}

open class OrderSummaryViewController: UITableViewController {
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

    override open func viewDidLoad() {
        super.viewDidLoad()

        let bundle = Bundle(for: HeaderView.self)
        tableView.register(UINib(nibName: "HeaderView", bundle: bundle), forHeaderFooterViewReuseIdentifier: headerViewIdentifier)
    }

    // MARK: UITableViewDataSource

    override open func numberOfSections(in tableView: UITableView) -> Int {
        return (order?.products.count ?? 0) + 1
    }

    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case billingSection:
            return payments.count + 1
        default:
            return (order!.products[section] as? BookingProduct)?.passes.count ?? 1
        }
    }

    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
            // TODO: This should also be fixed in coming PRs
            let pass = (order!.products.first as? BookingProduct)?.passes[indexPath.row]
            cell.titleLabel.text = pass?.name
            cell.subTitleLabel.text = pass?.description
            cell.priceLabel.text = pass?.price.localizedDescriptionInBaseCurrency
            return cell
        }
    }

    // MARK: UITableViewDelegate

    override open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
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

    override open func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case billingSection:
            return HeaderView.boundingSize(with: tableView.bounds.size, title: "Billing Information", disclaimer: nil).height
        default:
            // TODO: It goes here as well ^
            return HeaderView.boundingSize(with: tableView.bounds.size, title: order?.products[section].title, disclaimer: nil).height
        }
    }

    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (billingSection, payments.count):
            guard let paymentHandlerViewControllerType = TravelerUI.shared?.paymentHandlerViewControllerType else {
                fatalError("SDK not initialized")
            }

            let vc = paymentHandlerViewControllerType.init()
            vc.delegate = self

            present(vc, animated: true)
        case (billingSection, _) where selectedPaymentIndex != indexPath.row:
            selectedPaymentIndex = indexPath.row
            tableView.reloadSections(IndexSet([billingSection]), with: .none)
        default:
            break
        }

        tableView.deselectRow(at: indexPath, animated: true)
    }

    override open func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {

        switch tableView.cellForRow(at: indexPath)?.reuseIdentifier{
        case infoCellIdentifier?:
            return true
        default:
            return false
        }
    }

    override open func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Remove") { (action, indexPath) in
            self.payments.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        return [deleteAction]
    }
}

extension OrderSummaryViewController: PaymentHandlerDelegate {
    public func paymentHandler(_ handler: PaymentHandler, didCollect payment: Payment) {
        guard !payments.contains(where:  { $0.securePayload() == payment.securePayload() }) else {
            return
        }

        payments.insert(payment, at: 0)
        selectedPaymentIndex = 0

        tableView.reloadData()
    }
}
