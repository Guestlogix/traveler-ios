//
//  WishlistResultViewController.swift
//  TravelerKitUI
//
//  Created by Ben Ruan on 2019-09-04.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

let wishlistCellIdentifier = "wishlistCellIdentifier"
let loadingCollectionCellIdentifier = "loadingCellIdentifier"

public protocol WishlistResultViewControllerDelegate: class {
    func wishlistResultViewControllerDidRefresh(_ controller: WishlistResultViewController)
}

open class WishlistResultViewController: UICollectionViewController {
    private var _volatileResult: WishlistResult?
    private var selectedCatalogItem: CatalogItem?
    private var pagesLoading = Set<Int>()

    // TODO: Make height dynamic
    private let edgeInset: CGFloat = 10
    private let cellHeight: CGFloat = 170

    public weak var delegate: WishlistResultViewControllerDelegate?

    public var wishlistResult: WishlistResult?

    override open func viewDidLoad() {
        super.viewDidLoad()

        _volatileResult = wishlistResult
    }

    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let navVC as UINavigationController):
            let vc = navVC.topViewController as? CatalogItemViewController
            vc?.catalogItem = selectedCatalogItem
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    // MARK: UICollectionViewDataSource

    override open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return wishlistResult?.total ?? 0
    }

    override open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let catalogItem = wishlistResult!.items[indexPath.row]

        switch catalogItem {
        case .none:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: loadingCollectionCellIdentifier, for: indexPath)
            cell.contentView.subviews.forEach({ $0.startShimmering() })
            return cell
        case .some(let item):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: wishlistCellIdentifier, for: indexPath) as! AvailabilityCell

            cell.titleLabel.text = item.title
            cell.descriptionLabel.text = item.subTitle
            cell.priceLabel.text = "Price starting at: \(item.price.localizedDescriptionInBaseCurrency ?? "")"
            cell.isAvailable = item.isAvailable
            cell.thumbnailImageView.image = nil

            if let url = item.imageURL {
                AssetManager.shared.loadImage(with: url) { [weak cell] (image) in
                    cell?.thumbnailImageView.image = image
                }
            } 

            cell.delegate = self

            return cell
        }
    }

    // MARK: UICollectionViewDelegate
    override open func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let catalogItem = wishlistResult!.items[indexPath.row]

        return catalogItem != nil ? true : false
    }

    override open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = wishlistResult!.items[indexPath.row] else {
            Log("Unknown item selected", data: nil, level: .error)
            return
        }

        if item.isAvailable == true {
            selectedCatalogItem = item
            collectionView.deselectItem(at: indexPath, animated: true)
            performSegue(withIdentifier: "itemSegue", sender: nil)
        } else {
            let alert = UIAlertController(title: "This item is no longer available. Do you want to remove it from your wishlist?", message: nil, preferredStyle: .alert)
            let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let yesAction = UIAlertAction(title: "Yes", style: .default) { [unowned self] _ in
                self.collectionView.performBatchUpdates({
                    if let result = Traveler.removeFromWishlist(item, result: self.wishlistResult, delegate: self) {
                        self.wishlistResult = result
                        self._volatileResult = result

                        self.collectionView.deleteItems(at: [indexPath])
                    }
                }, completion: nil)
            }
            alert.addAction(noAction)
            alert.addAction(yesAction)

            present(alert, animated: true)
        }
    }
}

extension WishlistResultViewController: UICollectionViewDataSourcePrefetching {
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let wishlistResult = wishlistResult else {
            return
        }

        let indexesRequested = indexPaths.map({ $0.row }).filter({ wishlistResult.items[$0] == nil })
        let pages = Set(indexesRequested.map({ $0 / WishlistQuery.pageSize }))
        let pagesNotRequested = pages.filter({ !wishlistResult.hasPage($0, pageSize: WishlistQuery.pageSize) })
        for page in pagesNotRequested where !pagesLoading.contains(page) {
            pagesLoading.insert(page)

            // TODO: This is now the second place we are using this. I think its a good opportunity to think about how we can refactor this code.
            let query = WishlistQuery(page: page, from: wishlistResult.fromDate, to: wishlistResult.toDate)
            Traveler.fetchWishlist(query, identifier: page, delegate: self)
        }
    }
}

extension WishlistResultViewController: AvailabilityCellDelegate {
    func availabilityCellDidPressRemoveButton(_ cell: AvailabilityCell) {
        guard let indexPath = collectionView.indexPath(for: cell), let item = wishlistResult?.items[indexPath.row] else {
            return
        }

        let alert = UIAlertController(title: "Are you sure you want to remove this item?", message: nil, preferredStyle: .alert)
        let noAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let yesAction = UIAlertAction(title: "Yes", style: .default) { [unowned self] _ in
            self.collectionView.performBatchUpdates({
                if let result = Traveler.removeFromWishlist(item, result: self.wishlistResult, delegate: self) {
                    self.wishlistResult = result
                    self._volatileResult = result

                    self.collectionView.deleteItems(at: [indexPath])
                }
            }, completion: nil)
        }

        alert.addAction(noAction)
        alert.addAction(yesAction)

        present(alert, animated: true)
    }
}

extension WishlistResultViewController: WishlistFetchDelegate {
    public func wishlistFetchDidSucceedWith(_ result: WishlistResult, identifier: AnyHashable?) {
        self.wishlistResult = _volatileResult

        _ = (identifier as? Int).flatMap({ pagesLoading.remove($0) })

        collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
    }

    public func wishlistFetchDidFailWith(_ error: Error, identifier: AnyHashable?) {
        _ = (identifier as? Int).flatMap({ pagesLoading.remove($0) })

        // HANDLE CASE WHERE THE RESULTS DONT MATCH
        switch error {
        case WishlistResultError.resultMismatch:
            pagesLoading.removeAll()
            delegate?.wishlistResultViewControllerDidRefresh(self)
        default:
            Log("Error fetching", data: error, level: .error)
            break
        }
    }

    public func previousResult() -> WishlistResult? {
        return _volatileResult
    }

    public func wishlistFetchDidReceive(_ result: WishlistResult, identifier: AnyHashable?) {
        _volatileResult = result
    }
}

extension WishlistResultViewController: WishlistRemoveDelegate {
    public func wishlistRemoveDidSucceedFor(_ item: Product, with itemDetails: CatalogItemDetails?) {
        // do nothing
    }

    public func wishlistRemoveDidFailWith(_ error: Error, result: WishlistResult?) {
        guard let result = result else {
            Log("Original wishlist result should be provided when calling wishlist remove in WishlistResultViewController.", data: nil, level: .error)
            return
        }

        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: { [unowned self] _ in
            self.wishlistResult = result
            self._volatileResult = result

            self.collectionView.reloadData()
        })

        alert.addAction(okAction)

        present(alert, animated: true)
    }
}

extension WishlistQuery {
    static let pageSize = 10

    init(page: Int, from: Date?, to: Date) {
        self.init(offset: page * WishlistQuery.pageSize, limit: WishlistQuery.pageSize, from: from, to: to)
    }
}

extension WishlistResult {
    func hasPage(_ page: Int, pageSize: Int) -> Bool {
        for i in (page * pageSize)..<((page + 1) * pageSize) where items[i] == nil {
            return false
        }

        return true
    }
}

extension WishlistResultViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.size.width
        let height = cellHeight

        return CGSize(width: width, height: height)
    }
}
