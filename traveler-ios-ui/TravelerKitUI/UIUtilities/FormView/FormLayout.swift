//
//  FormLayout.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-01-24.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import UIKit

protocol UICollectionViewDelegateFormLayout: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterAt indexPath: IndexPath) -> CGSize
}

class FormLayout: UICollectionViewLayout {
    private var contentSize: CGSize?
    private var headerLayoutAttributes = [Int: UICollectionViewLayoutAttributes]()
    private var itemLayoutAttributes = [IndexPath: UICollectionViewLayoutAttributes]()
    private var itemFooterLayoutAttributes = [IndexPath: UICollectionViewLayoutAttributes]()

    override func prepare() {
        guard let collectionView = collectionView else {
            return
        }

        /// Clear attributes

        self.headerLayoutAttributes = [:]
        self.itemLayoutAttributes = [:]
        self.itemFooterLayoutAttributes = [:]

        /// Calculate attributes

        let numSections = collectionView.numberOfSections
        let collectionViewDelegate = collectionView.delegate as? UICollectionViewDelegateFormLayout

        var width: CGFloat = 0
        var height: CGFloat = 0

        for section in 0..<numSections {
            let numItems = collectionView.numberOfItems(inSection: section)
            let headerSize = collectionViewDelegate?.collectionView(collectionView, layout: self, referenceSizeForHeaderInSection: section) ?? .zero

            if headerSize != .zero {
                let attributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                                                                        with: IndexPath(item: 0, section: section))
                attributes.frame = CGRect(origin: CGPoint(x: 0, y: height), size: headerSize)

                headerLayoutAttributes[section] = attributes
            }

            width = max(width, headerSize.width)
            height += headerSize.height

            for item in 0..<numItems {
                let indexPath = IndexPath(item: item, section: section)
                let size = collectionViewDelegate?.collectionView(collectionView, layout: self, sizeForItemAt: indexPath) ?? .zero

                /// Item

                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = CGRect(origin: CGPoint(x: 0, y: height), size: size)

                itemLayoutAttributes[indexPath] = attributes

                width = max(width, size.width)
                height += size.height

                /// Item Footer

                if let footerSize = collectionViewDelegate?.collectionView(collectionView, layout: self, referenceSizeForFooterAt: indexPath), footerSize != .zero {
                    let footerAttributes = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: elementKindFieldFooter, with: indexPath)
                    footerAttributes.frame = CGRect(origin: CGPoint(x: 0, y: height), size: footerSize)

                    itemFooterLayoutAttributes[indexPath] = footerAttributes

                    width = max(width, footerSize.width)
                    height += footerSize.height
                }
            }
        }

        self.contentSize = CGSize(width: width, height: height)
    }

    override var collectionViewContentSize: CGSize {
        return contentSize ?? .zero
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var collection = [UICollectionViewLayoutAttributes]()

        for (_, attributes) in itemLayoutAttributes where attributes.frame.intersects(rect) {
            collection.append(attributes)
        }

        for (_, attribtues) in headerLayoutAttributes where attribtues.frame.intersects(rect) {
            collection.append(attribtues)
        }

        for (_, attributes) in itemFooterLayoutAttributes where attributes.frame.intersects(rect) {
            collection.append(attributes)
        }

        return collection
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemLayoutAttributes[indexPath]
    }

    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        switch elementKind {
        case UICollectionView.elementKindSectionHeader:
            return headerLayoutAttributes[indexPath.section]
        case elementKindFieldFooter:
            return itemFooterLayoutAttributes[indexPath]
        default:
            return nil
        }
    }

    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)
        attributes?.alpha = 1.0
        return attributes
    }

    override func finalLayoutAttributesForDisappearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.finalLayoutAttributesForDisappearingItem(at: itemIndexPath)
        attributes?.transform = attributes!.transform.scaledBy(x: 0, y: 0.1)
        attributes?.alpha = 1.0
        return attributes
    }
}
