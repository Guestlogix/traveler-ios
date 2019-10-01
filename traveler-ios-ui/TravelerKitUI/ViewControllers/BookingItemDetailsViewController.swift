//
//  BookingItemDetailsViewController.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-08.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit
import TravelerKit

let imageCellIdentifier = "imageCellIdentifier"

protocol BookingItemDetailsViewControllerDelegate: class {
    func catalogItemResultViewControllerDidChangePreferredTranslucency(_ controller: BookingItemDetailsViewController)
}

class BookingItemDetailsViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var itemInfoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemInfoView: UIView!
    @IBOutlet weak var termsAndConditionsButton: UIButton!
    
    weak var delegate: BookingItemDetailsViewControllerDelegate?
    var bookingItemDetails: BookingItemDetails?

    private(set) var preferredTranslucency: Bool = true

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = bookingItemDetails?.title
        let description = bookingItemDetails?.attributedDescription
        description?.setFontFace(font: UIFont.systemFont(ofSize: 17))
        descriptionLabel.attributedText = description

        // Preload images

        bookingItemDetails?.imageUrls.forEach({ (imageURL) in
            AssetManager.shared.loadImage(with: imageURL, completion: { _ in
                // no-op
            })
        })

        termsAndConditionsButton.isEnabled = bookingItemDetails?.attributedTermsAndConditions != nil
    }

    override func viewWillDisappear(_ animated: Bool) {
        if preferredTranslucency {
            preferredTranslucency = false
            delegate?.catalogItemResultViewControllerDidChangePreferredTranslucency(self)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        updatePreferredTranslucency()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as CatalogItemInfoViewController):
            vc.delegate = self
            vc.details = bookingItemDetails
        case (_, let vc as PurchaseViewController):
            vc.product = bookingItemDetails
        case (_, let vc as SupplierInfoViewController):
            vc.supplier = bookingItemDetails?.supplier
        case ("termsAndConditionsSegue", let navVC as UINavigationController):
            let vc = navVC.topViewController as? TermsAndConditionsViewController
            vc?.termsAndConditions = bookingItemDetails?.attributedTermsAndConditions
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    @IBAction func didSelectTermsAndConditions(_ sender: Any) {
        performSegue(withIdentifier: "termsAndConditionsSegue", sender: nil)
    }
}

extension BookingItemDetailsViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookingItemDetails?.imageUrls.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellIdentifier, for: indexPath) as! ImageCell
        let imageURL = bookingItemDetails!.imageUrls[indexPath.row]

        AssetManager.shared.loadImage(with: imageURL) { (image) in
            cell.imageView.image = image
        }

        return cell
    }
}

extension BookingItemDetailsViewController: CatalogItemInfoViewControllerDelegate {
    func catalogItemInfoViewControllerDidChangePreferredContentSize(_ controller: CatalogItemInfoViewController) {
        itemInfoView.isHidden = controller.preferredContentSize.height == 0
        itemInfoHeightConstraint.constant = controller.preferredContentSize.height
        view.layoutIfNeeded()
    }
}

extension BookingItemDetailsViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updatePreferredTranslucency()
    }

    func updatePreferredTranslucency() {
        let cutOffPoint = headerView.frame.height - 75

        if scrollView.contentOffset.y > cutOffPoint && preferredTranslucency {
            preferredTranslucency = false
            scrollView.contentInsetAdjustmentBehavior = .always
            delegate?.catalogItemResultViewControllerDidChangePreferredTranslucency(self)
        } else if scrollView.contentOffset.y <= cutOffPoint && !preferredTranslucency {
            preferredTranslucency = true
            scrollView.contentInsetAdjustmentBehavior = .never
            delegate?.catalogItemResultViewControllerDidChangePreferredTranslucency(self)
        }
    }
}
