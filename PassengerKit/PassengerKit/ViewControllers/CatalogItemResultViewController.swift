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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var purchaseDetailsHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var purchaseDetialsView: UIView!
    @IBOutlet weak var itemInfoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemInfoView: UIView!

    weak var delegate: CatalogItemResultViewControllerDelegate?
    var catalogItemDetails: CatalogItemDetails?

    private var purchaseDetails: PurchaseDetails?
    private let errorContext = ErrorContext()
    private lazy var purchaseContext: BookingContext? = {
        return catalogItemDetails.flatMap({ BookingContext(product: $0) })
    }()
    /*
    private lazy var purchaseContext: PurchaseContext? {
        switch catalogItemDetails {
        case .some(let item) where item.purchaseStrategy == .bookable:
            return BookingContext(item)
        case .some(let item) where item.purchaseStrategy == .buyable:
            return BuyingContext(item)
        default:
            return nil
        }
    }
 */

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

        errorContext.addObserver(self)
    }

    deinit {
        errorContext.removeObserver(self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as PurchaseDetailsViewController):
            vc.delegate = self
            vc.catalogItemDetails = catalogItemDetails
            vc.errorContext = errorContext
            vc.purchaseContext = purchaseContext
        case (_, let vc as CatalogItemInfoViewController):
            vc.delegate = self
            vc.details = catalogItemDetails
        case (_, let vc as PurchaseViewController):
            vc.strategy = catalogItemDetails?.purchaseStrategy
            vc.errorContext = errorContext
            vc.purchaseContext = purchaseContext
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

    func purchaseDetailsViewControllerDidSelectDetails(_ controller: PurchaseDetailsViewController) {
        self.purchaseDetails = controller.purchaseDetails
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
            scrollView.contentInsetAdjustmentBehavior = .always
            delegate?.catalogItemResultViewControllerDidChangePreferredTranslucency(self)
        } else if scrollView.contentOffset.y <= cutOffPoint && !preferredTranslucency {
            preferredTranslucency = true
            scrollView.contentInsetAdjustmentBehavior = .never
            delegate?.catalogItemResultViewControllerDidChangePreferredTranslucency(self)
        }
    }
}

extension CatalogItemResultViewController: PurchaseViewControllerDelegate {
    func purchaseDetailsForPurchaseViewController(_ controller: PurchaseViewController) -> PurchaseDetails? {
        switch (catalogItemDetails?.purchaseStrategy, purchaseDetails) {
        case (.some(.bookable), .none):
            scrollView.setContentOffset(purchaseDetialsView.frame.origin, animated: true)
            return nil
        case (.some(.bookable), .some(let details)):
            return details
        default:
            return nil
        }
    }

    func purchaseViewController(_ controller: PurchaseViewController, didProduce bookingContext: BookingContext) {
        performSegue(withIdentifier: "passSegue", sender: bookingContext)
    }
}

extension CatalogItemResultViewController: ErrorContextObserving {
    func errorContextDidUpdate(_ context: ErrorContext) {
        if context.error != nil {
            scrollView.scrollRectToVisible(purchaseDetialsView.frame, animated: true)
        }
    }
}
