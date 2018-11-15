//
//  CatalogItemResultViewController.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-11-08.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

let imageCellIdentifier = "imageCellIdentifier"

protocol CatalogItemResultViewControllerDelegate: class {
    func catalogItemResultViewControllerDidChangePreferredTranslucency(_ controller: CatalogItemResultViewController)
}

class CatalogItemResultViewController: UIViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var purchaseDetailsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var purchaseDetialsView: UIView!
    @IBOutlet weak var itemInfoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemInfoView: UIView!

    weak var delegate: CatalogItemResultViewControllerDelegate?
    var catalogItemDetails: CatalogItemDetails?

    private(set) var preferredTranslucency: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = catalogItemDetails?.title
        let description = catalogItemDetails?.attributedDescription
        description?.setFontFace(font: UIFont.systemFont(ofSize: 17))
        descriptionLabel.attributedText = description

        // Preload images

        catalogItemDetails?.imageUrls.forEach({ (imageURL) in
            AssetManager.shared.loadImage(with: imageURL, completion: { _ in
                // no-op
            })
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as PurchaseDetailsViewController):
            vc.delegate = self
            vc.strategy = catalogItemDetails?.purchaseStrategy
        case (_, let vc as CatalogItemInfoViewController):
            vc.delegate = self
            vc.details = catalogItemDetails
        case (_, let vc as PurchaseViewController):
            vc.strategy = catalogItemDetails?.purchaseStrategy
            vc.delegate = self
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }
}

extension CatalogItemResultViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return catalogItemDetails?.imageUrls.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellIdentifier, for: indexPath) as! ImageCell
        let imageURL = catalogItemDetails!.imageUrls[indexPath.row]

        AssetManager.shared.loadImage(with: imageURL) { (image) in
            cell.imageView.image = image
        }

        return cell
    }
}

extension CatalogItemResultViewController: PurchaseDetailsViewControllerDelgate {
    func purchaseDetailsViewControllerDidChangePreferredContentSize(_ controller: PurchaseDetailsViewController) {
        purchaseDetialsView.isHidden = controller.preferredContentSize.height == 0
        purchaseDetailsHeightConstraint.constant = controller.preferredContentSize.height
        view.layoutIfNeeded()
    }
}

extension CatalogItemResultViewController: CatalogItemInfoViewControllerDelegate {
    func catalogItemInfoViewControllerDidChangePreferredContentSize(_ controller: CatalogItemInfoViewController) {
        itemInfoView.isHidden = controller.preferredContentSize.height == 0
        itemInfoHeightConstraint.constant = controller.preferredContentSize.height
        view.layoutIfNeeded()
    }
}

extension CatalogItemResultViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let cutOffPoint = headerView.frame.height - 75

        if scrollView.contentOffset.y > cutOffPoint && preferredTranslucency {
            preferredTranslucency = false
            delegate?.catalogItemResultViewControllerDidChangePreferredTranslucency(self)
        } else if scrollView.contentOffset.y <= cutOffPoint && !preferredTranslucency {
            preferredTranslucency = true
            delegate?.catalogItemResultViewControllerDidChangePreferredTranslucency(self)
        }
    }
}

extension CatalogItemResultViewController: PurchaseViewControllerDelegate {

}
