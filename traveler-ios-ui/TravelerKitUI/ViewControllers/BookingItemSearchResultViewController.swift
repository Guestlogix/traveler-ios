//
//  BookingItemSearchResultViewController.swift
//  Traveler
//
//  Created by Omar Padierna on 2019-08-07.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

open class BookingItemSearchResultViewController: UIViewController {
    @IBOutlet weak var resultsCollectionView: UICollectionView!

    var bookingItemResult: BookingItemSearchResult?
    var searchQuery: BookingItemQuery?

    private var selectedCatalogItem: BookingItem?
    private var _volatileResult: BookingItemSearchResult?
    private var pagesLoading = Set<Int>()

    override open func viewDidLoad() {
        super.viewDidLoad()

        resultsCollectionView.register(UINib(nibName: "CarouselItemViewCell", bundle: Bundle(identifier: "com.guestlogix.TravelerKitUI")), forCellWithReuseIdentifier: "catalogItemCell")
        resultsCollectionView.dataSource = self
        resultsCollectionView.delegate = self
        resultsCollectionView.prefetchDataSource = self

        _volatileResult = bookingItemResult
    }

    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let navVC as UINavigationController):
            let catalogItemVC = navVC.topViewController as! CatalogItemViewController
            catalogItemVC.catalogItem = selectedCatalogItem
        default:
            Log("Unknown segue", data: nil, level: .warning)
        }
    }
}

extension BookingItemSearchResultViewController: UICollectionViewDataSource, UICollectionViewDelegate {

    //MARK: UICollectionViewDataSource

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "headerCollectionView", for: indexPath) as! CollectionHeaderView
        headerView.label.text = "\(bookingItemResult?.total ?? 0) items found"
        return headerView
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return bookingItemResult?.total ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = bookingItemResult!.items[indexPath.row]

        switch item {
        case .none:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "loadingCell", for: indexPath)
            cell.contentView.subviews.forEach({ $0.startShimmering() })
            return cell
        case .some(let catalogItem):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "catalogItemCell", for: indexPath) as! CarouselItemViewCell

            if let url = catalogItem.imageURL {
                AssetManager.shared.loadImage(with: url) { [weak cell] (image) in
                    cell?.imageView.image = image
                }
            }

            cell.titleLabel.text = item?.title
            cell.subTitleLabel?.text = item?.subTitle
            cell.priceLabel.text = item?.price.localizedDescriptionInBaseCurrency

            return cell
        }

    }

    //MARK: UICollectionViewDelegate

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCatalogItem = bookingItemResult!.items[indexPath.row]
        performSegue(withIdentifier: "itemSegue" , sender: nil)
    }
}

extension BookingItemSearchResultViewController: UICollectionViewDataSourcePrefetching {
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        guard let catalogItemResult = bookingItemResult, let searchQuery = searchQuery else {
            return
        }

        let indexesRequested = indexPaths.map({ $0.row }).filter({ catalogItemResult.items[$0] == nil })
        let pages = Set(indexesRequested.map({ $0 / BookingItemQuery.pageSize }))
        let pagesNotRequested = pages.filter({ !catalogItemResult.hasPage($0, pageSize: BookingItemQuery.pageSize) })
        for page in pagesNotRequested where !pagesLoading.contains(page) {
            pagesLoading.insert(page)

            let query = BookingItemQuery(page: page, for: searchQuery)
            Traveler.searchBookingItems(query, identifier: page, delegate: self)
        }

    }
}

extension BookingItemSearchResultViewController: BookingItemSearchDelegate {

    public func bookingItemSearchDidSucceedWith(_ result: BookingItemSearchResult, identifier: AnyHashable?) {
        self.bookingItemResult = _volatileResult

        _ = (identifier as? Int).flatMap({ pagesLoading.remove($0) })

        _ = resultsCollectionView.indexPathsForVisibleItems.compactMap({ resultsCollectionView.reloadItems(at: [$0]) })
    }

    public func bookingItemSearchDidReceive(_ result: BookingItemSearchResult, identifier: AnyHashable?) {
        _volatileResult = result
    }

    public func bookingItemSearchDidFailWith(_ error: Error, identifier: AnyHashable?) {
        _ = (identifier as? Int).flatMap({ pagesLoading.remove($0) })

        Log("Error searching for catalog item", data: error, level: .error)
    }

    public func previousResult() -> BookingItemSearchResult? {
        return _volatileResult
    }
}

extension BookingItemQuery {
    static let pageSize = 10

    init(page: Int, for query: BookingItemQuery) {
        self.init(offset: page * BookingItemQuery.pageSize, take: query.limit, text: query.text, range: query.priceRange, categories: query.categories, boundingBox: query.boundingBox, country: query.country, city: query.city, sortOption: query.sortOption, sortOrder: query.sortOrder)
    }
}

extension BookingItemSearchResult {
    func hasPage(_ page: Int, pageSize: Int) -> Bool {
        for i in (page * pageSize)..<((page + 1) * pageSize) where items[i] == nil {
            return false
        }
        return true
    }
}
