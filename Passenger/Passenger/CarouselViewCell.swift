//
//  CarouselViewCell.swift
//  Passenger
//
//  Created by Ata Namvari on 2018-10-03.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import UIKit

protocol CarouselViewCellDataSource: class {
    func numberOfItemsInCell(_ cell: CarouselViewCell) -> Int
    func carouselCell(_ cell: CarouselViewCell, configure itemCell: CarouselItemViewCell, at index: Int)
}

protocol CarouselViewCellDelegate: class {
    func carouselCellDidPressMoreButton(_ cell: CarouselViewCell)
    func sizeForItemsInCell(_ cell: CarouselViewCell) -> CGSize
    func carouselCell(_ cell: CarouselViewCell, didSelectItemAt index: Int)
}

let carouselItemCellIdentifier = "carouselItemCellIdentifier"

class CarouselViewCell: UITableViewCell {
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var moreButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!

    weak var dataSource: CarouselViewCellDataSource?
    weak var delegate: CarouselViewCellDelegate?

    private var itemSize = CGSize.zero

    override func awakeFromNib() {
        super.awakeFromNib()

        collectionView.register(UINib(nibName: "CarouselItemViewCell", bundle: nil), forCellWithReuseIdentifier: carouselItemCellIdentifier)
    }

    @IBAction func didPressMoreButton(_ sender: UIButton) {
        delegate?.carouselCellDidPressMoreButton(self)
    }

    func reload() {
        itemSize = delegate?.sizeForItemsInCell(self) ?? .zero
        collectionView.reloadData()
    }
}

extension CarouselViewCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource?.numberOfItemsInCell(self) ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: carouselItemCellIdentifier, for: indexPath) as! CarouselItemViewCell
        dataSource?.carouselCell(self, configure: cell, at: indexPath.row)
        return cell
    }
}

extension CarouselViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = itemSize
        size.height += (2 * CarouselItemViewCell.margin) + CarouselItemViewCell.footerHeight
        size.width += (2 * CarouselItemViewCell.margin)
        return size
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.carouselCell(self, didSelectItemAt: indexPath.row)
    }
}

extension CarouselViewCell {
    static var headerHeight: CGFloat {
        return 50
    }
}
