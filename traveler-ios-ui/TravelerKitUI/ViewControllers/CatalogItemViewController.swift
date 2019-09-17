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

    private var details: CatalogItemDetails?
    private var product: Product?
    private var bookingForm: BookingForm?

    open override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        reload()
    }

    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case ("loadingSegue", _):
            break
        case (_, let vc as RetryViewController):
            vc.delegate = self
        case (_, let vc as PurchaseViewController):
            vc.itemDetails = details
            vc.product = product
        default:
            Log("Unknown segue", data: nil, level: .warning)
            break
        }
    }

    func reload() {
        guard let catalogItem = catalogItem else {
            performSegue(withIdentifier: "errorSegue", sender: nil)
            return
        }

        switch catalogItem {
        case let catalogItem as Product:
            performSegue(withIdentifier: "loadingSegue", sender: nil)
            Traveler.fetchProductDetails(catalogItem, delegate: self)
            product = catalogItem
        default:
            Log("Unknown CatalogItem Type", data: nil, level: .error)
            performSegue(withIdentifier: "errorSegue", sender: nil)
        }

    }

    @IBAction func didClose(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension CatalogItemViewController: CatalogItemDetailsFetchDelegate {
    public func catalogItemDetailsFetchDidSucceedWith(_ result: CatalogItemDetails) {
        details = result
        performSegue(withIdentifier: "resultSegue", sender: nil)
    }

    public func catalogItemDetailsFetchDidFailWith(_ error: Error) {
        performSegue(withIdentifier: "errorSegue", sender: nil)
    }
}

extension CatalogItemViewController: RetryViewControllerDelegate {
    func retryViewControllerDidRetry(_ controller: RetryViewController) {
        reload()
    }
}
