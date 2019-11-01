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
    func bookingItemDetailsViewControllerDidChangePreferredTranslucency(_ controller: BookingItemDetailsViewController)
    func bookingItemDetailsViewController(_ controller: BookingItemDetailsViewController, didFinishWith purchaseForm: PurchaseForm)
}

public class BookingItemDetailsViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var wishlistButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var itemInfoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemInfoView: UIView!
    @IBOutlet weak var termsAndConditionsButton: UIButton!
    @IBOutlet weak var descriptionLabelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var similarItemsHeightConstraint: NSLayoutConstraint!
    
    weak var delegate: BookingItemDetailsViewControllerDelegate?
    var bookingItemDetails: BookingItemDetails?
    var product: BookingItem?

    private(set) var preferredTranslucency: Bool = true

    override public func viewDidLoad() {
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


        termsAndConditionsButton.isHidden = bookingItemDetails?.attributedTermsAndConditions == nil
        descriptionLabelBottomConstraint.constant = bookingItemDetails?.attributedTermsAndConditions == nil ? 0: termsAndConditionsButton.frame.height + 10
    }

    override public func viewWillDisappear(_ animated: Bool) {
        if preferredTranslucency {
            preferredTranslucency = false
            delegate?.bookingItemDetailsViewControllerDidChangePreferredTranslucency(self)
        }
    }

    override public func viewWillAppear(_ animated: Bool) {
        updatePreferredTranslucency()

        wishlistButton.isSelected = bookingItemDetails?.isWishlisted ?? false
    }

    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as CatalogItemInfoViewController):
            vc.delegate = self
            vc.details = bookingItemDetails
        case (_, let vc as BookablePurchaseViewController):
            vc.product = product
            vc.delegate = self
        case (_, let vc as SupplierInfoViewController):
            vc.supplier = bookingItemDetails?.supplier
        case (_, let vc as SimilarItemsViewController):
            vc.delegate = self
            vc.product = product
        case ("termsAndConditionsSegue", let navVC as UINavigationController):
            let vc = navVC.topViewController as? TermsAndConditionsViewController
            vc?.termsAndConditions = bookingItemDetails?.attributedTermsAndConditions
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    @IBAction func didPressWishlistButton(_ sender: UIButton) {
        guard let product = product else {
            Log("Unknown product.", data: nil, level: .error)
            return
        }

        if let isWishlisted = bookingItemDetails?.isWishlisted, isWishlisted == true {
            wishlistButton.isSelected = false
            Traveler.removeFromWishlist(product, result: nil, delegate: self)
        } else {
            wishlistButton.isSelected = true
            Traveler.addToWishlist(product, delegate: self)
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

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookingItemDetails?.imageUrls.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCellIdentifier, for: indexPath) as! ImageCell
        let imageURL = bookingItemDetails!.imageUrls[indexPath.row]

        AssetManager.shared.loadImage(with: imageURL) { (image) in
            cell.imageView.image = image
        }

        return cell
    }
}

extension BookingItemDetailsViewController: CatalogItemInfoViewControllerDelegate {
    public func catalogItemInfoViewControllerDidChangePreferredContentSize(_ controller: CatalogItemInfoViewController) {
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
            delegate?.bookingItemDetailsViewControllerDidChangePreferredTranslucency(self)
        } else if scrollView.contentOffset.y <= cutOffPoint && !preferredTranslucency {
            preferredTranslucency = true
            scrollView.contentInsetAdjustmentBehavior = .never
            delegate?.bookingItemDetailsViewControllerDidChangePreferredTranslucency(self)
        }
    }
}

extension BookingItemDetailsViewController: BookablePurchaseViewControllerDelegate {
    public func bookablePurchaseViewController(_ controller: BookablePurchaseViewController, didFinishWith purchaseForm: PurchaseForm) {
        delegate?.bookingItemDetailsViewController(self, didFinishWith: purchaseForm)
    }
}

extension BookingItemDetailsViewController: WishlistAddDelegate {
    public func wishlistAddDidSucceedFor(_ item: Product, with itemDetails: CatalogItemDetails) {
        guard let details = itemDetails as? BookingItemDetails else {
            Log("Unknown CatalogItemDetails type", data: itemDetails, level: .error)
            return
        }

        bookingItemDetails = details
    }

    public func wishlistAddDidFailWith(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: { [unowned self] _ in
            self.wishlistButton.isSelected = false
        })

        alert.addAction(okAction)

        present(alert, animated: true)
    }
}

extension BookingItemDetailsViewController: WishlistRemoveDelegate {
    public func wishlistRemoveDidSucceedFor(_ item: Product, with itemDetails: CatalogItemDetails?) {
        switch itemDetails {
        case .some(let details as BookingItemDetails):
            bookingItemDetails = details
        case .some:
            Log("Unknown CatalogItemDetails type", data: itemDetails, level: .error)
        case .none:
            let alert = UIAlertController(title: "Item is no longer available.", message: nil, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: { [unowned self] _ in
                self.dismiss(animated: true, completion: nil)
            })

            alert.addAction(okAction)

            present(alert, animated: true)
        }
    }

    public func wishlistRemoveDidFailWith(_ error: Error, result: WishlistResult?) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: { [unowned self] _ in
            self.wishlistButton.isSelected = true
        })

        alert.addAction(okAction)

        present(alert, animated: true)
    }
}

extension BookingItemDetailsViewController: SimilarItemsViewControllerDelegate {
    public func similarItemsViewController(_ controller: SimilarItemsViewController, didFailWith: Error) {
        // Collapse the view when there is an error
        similarItemsHeightConstraint.constant = 0
        view.layoutIfNeeded()
    }
}
