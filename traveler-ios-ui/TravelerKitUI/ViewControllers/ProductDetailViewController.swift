//
//  ProductDetailViewController.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-05-30.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

open class ProductDetailViewController: UIViewController {
    var product: Product?

    private var productDetails: CatalogItemDetails?

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        reload()
    }

    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination, productDetails) {
        case (_, let vc as BookableProductDetailViewController, let productDetails as BookingItemDetails):
            vc.purchasedProduct = product as? BookingProduct
            vc.productDetails = productDetails
        case (_, let vc as RetryViewController, _):
            vc.delegate = self
            vc.errorMessageLabel.text = "An error occured while loading your product :("
        case ("loadingSegue", _, _):
            break
        default:
            Log("Unknown segue", data: nil, level:.warning)
            break
        }
    }

    func reload() {
        guard let product = product else {
            performSegue(withIdentifier: "errorSegue", sender: nil)
            return
        }

        performSegue(withIdentifier: "loadingSegue", sender: nil)

        Traveler.fetchProductDetails(product, delegate: self)
    }

    @IBAction func didClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension ProductDetailViewController: CatalogItemDetailsFetchDelegate {
    public func catalogItemDetailsFetchDidSucceedWith(_ result: CatalogItemDetails) {
        switch result {
        case let result as BookingItemDetails:
            self.productDetails = result
            performSegue(withIdentifier: "bookableDetailSegue", sender: nil)
        default:
            Log("Unkown detail type", data: nil, level: .error)
            performSegue(withIdentifier: "errorSegue", sender: nil)
        }
    }

    public func catalogItemDetailsFetchDidFailWith(_ error: Error) {
        performSegue(withIdentifier: "errorSegue", sender: nil)
    }
}

extension ProductDetailViewController: RetryViewControllerDelegate {
    public func retryViewControllerDidRetry(_ controller: RetryViewController) {
        reload()
    }
}

