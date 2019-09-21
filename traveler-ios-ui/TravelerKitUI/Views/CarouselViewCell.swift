//
//  CarouselViewCell.swift
//  Traveler
//
//  Created by Ata Namvari on 2018-10-03.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import UIKit

public protocol CarouselViewCellDataSource: class {
    func numberOfItemsInCell(_ cell: CarouselViewCell) -> Int
    func carouselCell(_ cell: CarouselViewCell, configure: CarouselItemViewCell, at: Int)
}

public protocol CarouselViewCellDelegate: class {
    func carouselCellDidPressMoreButton(_ cell: CarouselViewCell)
    func sizeForItemsInCell(_ cell: CarouselViewCell) -> CGSize
    func identifierForItemsInCell(_ cell: CarouselViewCell) -> String
    func carouselCell(_ cell: CarouselViewCell, didSelectItemAt index: Int)
}

let carouselItemCellIdentifier = "carouselItemCellIdentifier"

open class CarouselViewCell: UITableViewCell {
    @IBOutlet open weak var headerLabel: UILabel!
    @IBOutlet open weak var moreButton: UIButton!
    @IBOutlet open weak var collectionView: UICollectionView!

    open weak var dataSource: CarouselViewCellDataSource?
    open weak var delegate: CarouselViewCellDelegate?

    private var itemSize = CGSize.zero
    
    open var itemNib: UINib {
        return UINib(nibName: "CarouselItemViewCell", bundle: Bundle(for: type(of: self)))
    }

    override open func awakeFromNib() {
        super.awakeFromNib()

        collectionView.register(itemNib, forCellWithReuseIdentifier: carouselItemCellIdentifier)
        self.separatorInset = .zero
        self.preservesSuperviewLayoutMargins = false
        self.layoutMargins = .zero
    }

    @IBAction func didPressMoreButton(_ sender: UIButton) {
        delegate?.carouselCellDidPressMoreButton(self)
    }

    public func reload() {
        itemSize = delegate?.sizeForItemsInCell(self) ?? .zero
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }
}

extension CarouselViewCell: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItemsInCell(self) ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: carouselItemCellIdentifier, for: indexPath) as! CarouselItemViewCell
        dataSource?.carouselCell(self, configure: cell, at: indexPath.row)
        return cell
    }
}

extension CarouselViewCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = itemSize
        size.height += (2 * CarouselItemViewCell.margin) + CarouselItemViewCell.footerHeight
        size.width += (2 * CarouselItemViewCell.margin)
        return size
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.carouselCell(self, didSelectItemAt: indexPath.row)
    }
}

extension CarouselViewCell {
    static var headerHeight: CGFloat {
        return 50
    }
}
