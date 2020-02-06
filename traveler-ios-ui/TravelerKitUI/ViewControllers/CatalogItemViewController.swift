//
//  CatalogItemViewController.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-07.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit
import TravelerKit

open class CatalogItemViewController: UIViewController {
    public var image: UIImage?
    public var catalogItem: CatalogItem?

    private var order: Order?
    
    open override func viewDidLoad() {
        super.viewDidLoad()

        switch catalogItem {
        case is Product:
            performSegue(withIdentifier: "productSegue", sender: nil)
        case is QueryItem:
            performSegue(withIdentifier: "querySegue", sender: nil)
        default:
            Log("Unknown CatalogItem Type", data: nil, level: .error)
            break
        }
    }

    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as ProductItemViewController):
            // TODO: Pass images for better loading experience
            vc.product = catalogItem as? Product
            vc.delegate = self
        case (_, let vc as QueryItemViewController):
            vc.queryItem = catalogItem as? QueryItem
            vc.delegate = self
        case (_, let vc as PaymentConfirmationViewController):
            vc.order = order
        default:
            Log("Unknown segue", data: nil, level: .warning)
            break
        }
    }

    @IBAction func didClose(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension CatalogItemViewController: ProductItemViewControllerDelegate {
    public func productItemViewController(_ controller: ProductItemViewController, didFinishWith purchaseForm: PurchaseForm) {
        ProgressHUD.show()

        Traveler.createOrder(purchaseForm: purchaseForm, delegate: self)
    }
}

extension CatalogItemViewController: QueryItemViewControllerDelegate {
    public func queryItemViewController(_ controller: QueryItemViewController, didFinishWith purchaseForm: PurchaseForm) {
        ProgressHUD.show()

        Traveler.createOrder(purchaseForm: purchaseForm, delegate: self)
    }
}

extension CatalogItemViewController: OrderCreateDelegate {
    public func orderCreationDidSucceed(_ order: Order) {
        ProgressHUD.hide()

        self.order = order

        performSegue(withIdentifier: "confirmationSegue", sender: nil)
    }

    public func orderCreationDidFail(_ error: Error) {
        ProgressHUD.hide()

        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "ok", style: .default, handler: nil)
        
        alert.addAction(okAction)

        present(alert, animated: true)
    }
}
