//
//  CatalogItemDetailsViewController.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-07.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit
import TravelerKit

public protocol CatalogItemDetailsViewControllerDelegate: class {
    func catalogItemDetailsViewControllerDelegate(_ controller: CatalogItemDetailsViewController, didFinishWith purchaseForm: PurchaseForm)
}

open class CatalogItemDetailsViewController: UIViewController {

    var itemDetails: CatalogItemDetails?
    var product: Product?

    weak var delegate: CatalogItemDetailsViewControllerDelegate?

    override open func viewDidLoad() {
        super.viewDidLoad()

        switch itemDetails {
        case is BookingItemDetails:
            performSegue(withIdentifier: "bookingSegue", sender: nil)
        default:
            Log("Unknown item type", data: itemDetails, level: .error)
            performSegue(withIdentifier: "errorSegue", sender: nil)
        }
    }

    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination, itemDetails) {
        case (_, let vc as BookingItemDetailsViewController , let details as BookingItemDetails):
            vc.bookingItemDetails = details
            vc.product = product as? BookingItem
            vc.delegate = self
        default:
            Log("Unknown segue", data: nil, level: .warning)
            break
        }
    }

}

extension CatalogItemDetailsViewController: BookingItemDetailsViewControllerDelegate {
    func bookingItemDetailsViewControllerDidChangePreferredTranslucency(_ controller: BookingItemDetailsViewController) {
        if controller.preferredTranslucency {
            UIView.animate(withDuration: 0.2, animations: {
                self.navigationController?.navigationBar.alpha = 0

                controller.titleLabel.alpha = 1
            }) { _ in
                self.navigationController?.navigationBar.alpha = 1
                self.navigationController?.navigationBar.isTranslucent = true
                self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
                self.navigationController?.navigationBar.shadowImage = UIImage()
                self.navigationItem.title = nil
            }
        } else {
            self.navigationController?.navigationBar.isTranslucent = true
            self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            self.navigationController?.navigationBar.shadowImage = nil
            self.navigationItem.title = itemDetails?.title

            self.navigationController?.navigationBar.alpha = 0
            UIView.animate(withDuration: 0.2) {
                self.navigationController?.navigationBar.alpha = 1

                controller.titleLabel.alpha = 0
            }
        }
    }

    func bookingItemDetailsViewController(_ controller: BookingItemDetailsViewController, didFinishWith purchaseForm: PurchaseForm) {
        delegate?.catalogItemDetailsViewControllerDelegate(self, didFinishWith: purchaseForm)
    }

}
