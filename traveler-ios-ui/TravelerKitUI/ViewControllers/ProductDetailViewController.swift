//
//  ProductDetailViewController.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-05-30.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

class ProductDetailViewController: UIViewController {
    public var product:Product?

    private var productDetails:CatalogItemDetails?


    override func viewDidLoad() {
        super.viewDidLoad()

//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()

        reload()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as BookableProductDetailViewController ):
            vc.purchasedProduct = product as? BookableProduct
            vc.productDetails = productDetails
        case ("errorSegue", _),
             ("loadingSegue", _):
            break
        default:
            Log("Unknown segue", data: nil, level:.warning)
        }
    }

    func reload() {
        guard let product = product else {
            performSegue(withIdentifier: "errorSegue", sender: nil)
            return
        }

        performSegue(withIdentifier: "loadingSegue", sender: nil)

        Traveler.fetchCatalogItemDetails(product, delegate: self)
    }

    @IBAction func didClose(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}

extension ProductDetailViewController: CatalogItemDetailsFetchDelegate {
    func catalogItemDetailsFetchDidSucceedWith(_ result: CatalogItemDetails) {
        self.productDetails = result

        if let _ = product as? BookableProduct {
            performSegue(withIdentifier:"bookableDetailSegue", sender: nil)
        } else {
            performSegue(withIdentifier: "errorSegue", sender: nil)
        }
    }

    func catalogItemDetailsFetchDidFailWith(_ error: Error) {
        performSegue(withIdentifier: "errorSegue", sender: nil)
    }
}

