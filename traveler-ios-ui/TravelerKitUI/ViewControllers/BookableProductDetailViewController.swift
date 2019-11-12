//
//  BookableProductDetailViewController.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-05-30.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

open class BookableProductDetailViewController: UIViewController {
    @IBOutlet weak var headerView: PagedHorizontalView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var passDetailsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var passDetailsView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var productDescriptionLabel: UILabel!
    @IBOutlet weak var productInfoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var productInfoView: UIView!

    var purchasedProduct: BookingProduct?
    var productDetails: BookingItemDetails?

    override public func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.isTranslucent = true

        productNameLabel.text = purchasedProduct?.title

        if let date = purchasedProduct?.eventDate {
            dateLabel.text = ISO8601DateFormatter.dateOnlyFormatter.string(from: date)
        }

        let description = productDetails?.attributedDescription
        description?.setFontFace(font: UIFont.systemFont(ofSize: 17))
        productDescriptionLabel.attributedText = description

        // Preload images

        productDetails?.imageUrls.forEach({ (imageURL) in
            AssetManager.shared.loadImage(with: imageURL, completion: { _ in
                // no-op
            })
        })
    }

    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination){
        case (_, let vc as AggregatedPassesViewController):
            vc.delegate = self
            vc.passes = purchasedProduct?.passes
        case (_, let vc as CatalogItemInfoViewController):
            vc.details = productDetails
            vc.delegate = self
        case (_ , let vc as SupplierInfoViewController):
            vc.supplier = productDetails?.supplier
        case ("termsAndConditionsSegue", let navVC as UINavigationController):
            let vc = navVC.topViewController as? TermsAndConditionsViewController
            vc?.termsAndConditions = productDetails?.attributedTermsAndConditions
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }
}

extension BookableProductDetailViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productDetails?.imageUrls.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellIdentifier, for: indexPath) as! ImageCell
        let imageURL = productDetails!.imageUrls[indexPath.row]

        AssetManager.shared.loadImage(with: imageURL) { (image) in
            cell.imageView.image = image
        }
        return cell
    }
}

extension BookableProductDetailViewController: AggregatedPassesViewControllerDelegate {
    public func aggregatedPasssesViewControllerDidChangePreferredContentSize(_ controller: AggregatedPassesViewController) {
        passDetailsView.isHidden = controller.preferredContentSize.height == 0
        passDetailsHeightConstraint.constant = controller.preferredContentSize.height
        view.layoutIfNeeded()
    }
}

extension BookableProductDetailViewController: CatalogItemInfoViewControllerDelegate {
    public func catalogItemInfoViewControllerDidChangePreferredContentSize(_ controller: CatalogItemInfoViewController) {
        productInfoView.isHidden = controller.preferredContentSize.height == 0
        productInfoHeightConstraint.constant = controller.preferredContentSize.height
        view.layoutIfNeeded()
    }
}
