//
//  ProductItemViewController.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-10-15.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit

public protocol ProductItemViewControllerDelegate: class {
    func productItemViewController(_ controller: ProductItemViewController, didFinishWith purchaseForm: PurchaseForm)
}

open class ProductItemViewController: UIViewController {
    public var product: Product?

    public weak var delegate: ProductItemViewControllerDelegate?

    private var details: CatalogItemDetails?

    override open func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        reload()
    }

    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case ("loadingSegue", _):
            break
        case (_, let vc as ErrorViewController):
            vc.delegate = self
        case (_, let vc as CatalogItemDetailsViewController):
            vc.itemDetails = details
            vc.product = product
            vc.delegate = self
        default:
            Log("Unknown segue", data: nil, level: .warning)
            break
        }
    }

    private func reload() {
        guard let product = product else {
            Log("No Product", data: nil, level: .error)
            return
        }

        performSegue(withIdentifier: "loadingSegue", sender: nil)

        Traveler.fetchProductDetails(product, delegate: self)
    }
}

extension ProductItemViewController: CatalogItemDetailsFetchDelegate {
    public func catalogItemDetailsFetchDidSucceedWith(_ result: CatalogItemDetails) {
        self.details = result

        performSegue(withIdentifier: "resultSegue", sender: nil)
    }

    public func catalogItemDetailsFetchDidFailWith(_ error: Error) {
        performSegue(withIdentifier: "errorSegue", sender: nil)
    }
}

extension ProductItemViewController: ErrorViewControllerDelegate {
    public func errorViewControllerDidRetry(_ controller: ErrorViewController) {
        reload()
    }
}

extension ProductItemViewController: CatalogItemDetailsViewControllerDelegate {
    public func catalogItemDetailsViewControllerDelegate(_ controller: CatalogItemDetailsViewController, didFinishWith purchaseForm: PurchaseForm) {
        delegate?.productItemViewController(self, didFinishWith: purchaseForm)
    }
}
