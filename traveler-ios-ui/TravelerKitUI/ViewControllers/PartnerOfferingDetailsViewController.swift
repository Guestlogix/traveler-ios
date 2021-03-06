//
//  PartnerOfferingDetailsViewController.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-11-27.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

public protocol PartnerOfferingDetailsViewControllerDelegate: class {
    func partnerOfferingDetailsViewController(_ controller: PartnerOfferingDetailsViewController, didFinishWith purchaseForm: PurchaseForm)
}

open class PartnerOfferingDetailsViewController: UIViewController {
    @IBOutlet weak var headerView: PagedHorizontalView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var optionsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var optionsView: UIView!

    var details: PartnerOfferingItemDetail?
    var product: PartnerOfferingItem?
    weak var delegate: PartnerOfferingDetailsViewControllerDelegate?

    override open func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = details?.title
        descriptionLabel.text = details?.description
        priceLabel.text = product?.price.localizedDescriptionInBaseCurrency
    }

    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as OfferingsDisplayViewController):
            vc.offeringsGroup = details?.offerings
            vc.delegate = self
        case (_, let vc as PartnerOfferingsFetchViewController):
            vc.product = product
            vc.delegate = self
        default:
            Log("Unknown segue", data: nil, level: .warning)
        }
    }
}

extension PartnerOfferingDetailsViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return details?.imageUrls.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellIdentifier, for: indexPath) as! ImageCell
        let imageURL = details!.imageUrls[indexPath.row]

        AssetManager.shared.loadImage(with: imageURL) { (image) in
            cell.imageView.image = image
        }
        return cell
    }
}

extension PartnerOfferingDetailsViewController: OfferingsDisplayViewControllerDelegate {
    public func offeringsDisplayViewControllerDidChangePreferredContentSize(_ controller: OfferingsDisplayViewController) {
        optionsView.isHidden = controller.preferredContentSize.height == 0
        optionsHeightConstraint.constant = controller.preferredContentSize.height
        view.layoutIfNeeded()
    }
}

extension PartnerOfferingDetailsViewController: PartnerOfferingsFetchViewControllerDelegate {
    public func partnerOfferingsFetchViewController(_ controller: PartnerOfferingsFetchViewController, didFinishWith purchaseForm: PurchaseForm) {
        delegate?.partnerOfferingDetailsViewController(self, didFinishWith: purchaseForm)
    }
}
