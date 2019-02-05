//
//  CatalogResultViewController.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-10-31.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit

let carouselCellIdentifier = "carouselCellIdentifier"

open class CatalogResultViewController: CatalogViewController {
    public var catalog: Catalog?
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        catalogView.register(UINib(nibName: "CarouselViewCell", bundle: Bundle(for: CatalogResultViewController.self)), forGroupWithIdentifier: standardIdentifier)
        catalogView.register(UINib(nibName: "FeaturedCarouselViewCell", bundle: Bundle(for: CatalogResultViewController.self)), forGroupWithIdentifier: featuredIdentifier)
    }

    @IBInspectable open var maxNumberOfItemsInGroup: Int = 5

    // MARK: CatalogViewDataSource

    open override func numberOfGroups(in catalogView: CatalogView) -> Int {
        return catalog?.groups.count ?? 0
    }

    open override func catalogView(_ catalogView: CatalogView, numberOfItemsIn group: Int) -> Int {
        return min(catalog!.groups[group].items.count, maxNumberOfItemsInGroup)
    }

    open override func catalogView(_ catalogView: CatalogView, configure itemCell: CarouselItemViewCell, at indexPath: IndexPath) {
        let item = catalog!.groups[indexPath.section].items[indexPath.row]
        itemCell.titleLabel.text = item.title
        itemCell.subTitleLabel?.text = item.subTitle
        itemCell.imageView.image = nil

        if let url = item.imageURL {
            AssetManager.shared.loadImage(with: url) { [weak itemCell] (image) in
                itemCell?.imageView.image = image
            }
        }
    }

    open override func catalogView(_ catalogView: CatalogView, titleForHeaderIn group: Int) -> String? {
        return catalog!.groups[group].title
    }

    open override func catalogView(_ catalogView: CatalogView, titleForAccessoryButtonIn group: Int) -> String? {
        return catalog!.groups[group].items.count > maxNumberOfItemsInGroup ? "See All" : nil
    }
    
    open override func catalogView(_ catalogView: CatalogView, identifierFor group: Int) -> String {
        let group = catalog!.groups[group]
        
        if group.isFeatured {
            return featuredIdentifier
        } else {
            return standardIdentifier
        }
    }

    // MARK: CatalogViewDelegate

    open override func catalogView(_ catalogView: CatalogView, sizeForItemsIn group: Int) -> CGSize {
        let group = catalog!.groups[group]

        if group.isFeatured {
            return featuredItemSize
        } else {
            return standardItemSize
        }
    }

    open override func catalogView(_ catalogView: CatalogView, spacingBetweenItemsIn group: Int) -> CGFloat {
        return CarouselItemViewCell.margin * 2
    }

    open override func catalogView(_ catalogView: CatalogView, didPressAccessoryButtonIn group: Int) {
        // present drilled down view controller
    }

    open override func catalogView(_ catalogView: CatalogView, didSelectItemAt indexPath: IndexPath) {
        // present CatalogItemViewController
    }

    // MARK: Helpers

    private let itemRatio: CGFloat = 16.0 / 9.0
    private let featuredIdentifier = "FeaturedCarouselViewCell"
    private let standardIdentifier = "CarouselViewCell"

    open var standardItemSize: CGSize {
        let value: CGFloat = 70
        return CGSize(width: (value * itemRatio), height: value)
    }

    open var featuredItemSize: CGSize {
        let value: CGFloat = 70
        return CGSize(width: ((value * itemRatio) * 2),
                      height: value)
    }
}
