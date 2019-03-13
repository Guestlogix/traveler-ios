//
//  CatalogItemViewController.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-07.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit
import TravelerKit

public protocol CatalogItemViewControllerDelegate: class {
    func catalogItemViewController(_ controller: CatalogItemViewController, didCreate order: Order)
}

open class CatalogItemViewController: UIViewController {
    public var image: UIImage?
    public var catalogItem: CatalogItem?
    public weak var delegate: CatalogItemViewControllerDelegate?

    private var details: CatalogItemDetails?

    open override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()

        reload()
    }

    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as CatalogItemLoadingViewController):
            vc.image = image
        case (_, let vc as CatalogItemErrorViewController):
            vc.image = image
            vc.delegate = self
        case (_, let vc as CatalogItemResultViewController):
            vc.catalogItemDetails = details
            vc.delegate = self
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

        performSegue(withIdentifier: "loadingSegue", sender: nil)

        Traveler.fetchCatalogItemDetails(catalogItem, delegate: self)
    }

    @IBAction func didClose(_ sender: Any) {
        dismiss(animated: true)
    }
}

extension CatalogItemViewController: CatalogItemDetailsFetchDelegate {
    public func catalogItemDetailsFetchDidSucceedWith(_ result: CatalogItemDetails) {
        self.details = result

        performSegue(withIdentifier: "resultSegue", sender: nil)
    }

    public func catalogItemDetailsFetchDidFailWith(_ error: Error) {
        performSegue(withIdentifier: "errorSegue", sender: nil)
    }
}

extension CatalogItemViewController: CatalogItemErrorViewControllerDelegate {
    func catalogItemErrorViewControllerDidRetry(_ controller: CatalogItemErrorViewController) {
        reload()
    }
}

extension CatalogItemViewController: CatalogItemResultViewControllerDelegate {
    func catalogItemResultViewControllerDidChangePreferredTranslucency(_ controller: CatalogItemResultViewController) {
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
            self.navigationItem.title = details?.title

            self.navigationController?.navigationBar.alpha = 0
            UIView.animate(withDuration: 0.2) {
                self.navigationController?.navigationBar.alpha = 1

                controller.titleLabel.alpha = 0
            }
        }
    }

    func catalogItemResultViewController(_ controller: CatalogItemResultViewController, didCreate order: Order) {
        delegate?.catalogItemViewController(self, didCreate: order)
    }
}
