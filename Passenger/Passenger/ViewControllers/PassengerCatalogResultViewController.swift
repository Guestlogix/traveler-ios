//
//  CatalogResultViewController.swift
//  Passenger
//
//  Created by Ata Namvari on 2018-10-25.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import Foundation
import PassengerKit

class PassengerCatalogResultViewController: CatalogResultViewController {
    private(set) var selectedGroupIndex: Int?
    private(set) var selectedPurchasableIndex: Int?
}
//
//class CatalogResultViewController2: UITableViewController {
//    var catalog: Catalog?
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        tableView.register(UINib(nibName: "CarouselViewCell", bundle: nil), forCellReuseIdentifier: purchasableGroupCellIdentifier)
//    }
//
//    // MARK: UITableViewDataSource
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return catalog?.groups.count ?? 0
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: purchasableGroupCellIdentifier, for: indexPath) as! CarouselViewCell
//        let group = catalog!.groups[indexPath.row]
//
//        cell.dataSource = self
//        cell.delegate = self
//        cell.headerLabel.text = group.title
//        cell.moreButton.setTitle("See more", for: .normal)
//        cell.reload()
//        cell.tag = indexPath.row
//
//        return cell
//    }
//
//    // MARK: UITableViewDelegate
//
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let group = catalog!.groups[indexPath.row]
//
//        if group.isFeatured {
//            return featuredItemSize.height + (2 * CarouselItemViewCell.margin) + CarouselViewCell.headerHeight + CarouselItemViewCell.footerHeight
//        } else {
//            return CatalogResultViewController.standardItemSize.height + (2 * CarouselItemViewCell.margin) + CarouselItemViewCell.footerHeight + CarouselViewCell.headerHeight
//        }
//    }
//}

//extension CatalogResultViewController: CarouselViewCellDataSource {
//    func numberOfItemsInCell(_ cell: CarouselViewCell) -> Int {
//        return catalog!.groups[cell.tag].items.count
//    }
//
//    func carouselCell(_ cell: CarouselViewCell, configure itemCell: CarouselItemViewCell, at index: Int) {
//        let purchasable = catalog!.groups[cell.tag].items[index]
//        itemCell.titleLable.text = purchasable.title
//        itemCell.subTitleLabel.text = purchasable.subTitle
//        itemCell.imageView.image = nil
//
//        if let url = purchasable.imageURL {
//            AssetManager.shared.loadImage(with: url) { [weak itemCell] (image) in
//                itemCell?.imageView.image = image
//            }
//        }
//    }
//}
//
//extension CatalogResultViewController: CarouselViewCellDelegate {
//    func sizeForItemsInCell(_ cell: CarouselViewCell) -> CGSize {
//        let group = catalog!.groups[cell.tag]
//
//        if group.isFeatured {
//            return featuredItemSize
//        } else {
//            return CatalogResultViewController.standardItemSize
//        }
//    }
//
//    func carouselCellDidPressMoreButton(_ cell: CarouselViewCell) {
//        let group = catalog!.groups[cell.tag]
//
//        // GOTO category VIEWCONTROLLER
//    }
//
//    func carouselCell(_ cell: CarouselViewCell, didSelectItemAt index: Int) {
//        let item = catalog!.groups[cell.tag].items[index]
//        let purchasableVC = UINib(nibName: "PurchasableViewController", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! CatalogItemViewController
//
//        self.selectedGroupIndex = cell.tag
//        self.selectedPurchasableIndex = index
//
//        //purchasableVC.transitioningDelegate = self
//        purchasableVC.modalPresentationStyle = .custom
//        purchasableVC.modalPresentationCapturesStatusBarAppearance = true
//
//        if let url = item.imageURL {
//            AssetManager.shared.loadImage(with: url) { [weak purchasableVC] (image) in
//                purchasableVC?.imageView.image = image
//            }
//        }
//        present(purchasableVC, animated: true)
//    }
//}
//
//extension CatalogResultViewController {
//    static var itemRatio: CGFloat {
//        return 16.0 / 9.0;
//    }
//
//    static var standardItemSize: CGSize {
//        let value: CGFloat = 60
//        return CGSize(width: (value * itemRatio), height: value)
//    }
//
//    var featuredItemSize: CGSize {
//        let value = tableView.bounds.width - (2 * CarouselItemViewCell.margin)
//        return CGSize(width: value,
//                      height: value * CatalogResultViewController.itemRatio)
//    }
//}
