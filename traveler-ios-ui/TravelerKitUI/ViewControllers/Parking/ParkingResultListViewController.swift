//
//  ParkingResultListViewController.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-10-08.
//  Copyright © 2019 Guestlogix Inc. All rights reserved.
//

import Foundation
import TravelerKit

let parkingCellIdentifier = "parkingCellIdentifier"

public protocol ParkingResultListViewControllerDelegate: class {
    func parkingResultListViewController(_ controller: ParkingResultListViewController, didFinishWith purchaseForm: PurchaseForm)
}

open class ParkingResultListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    public var context: ParkingResultContext?
    public weak var delegate: ParkingResultListViewControllerDelegate?

    override open func viewDidLoad() {
        super.viewDidLoad()

        context?.addObserver(self)

        collectionView.decelerationRate = .fast
    }

    deinit {
        context?.removeObserver(self)
    }

    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as ParkingItemDetailViewController):
            vc.parkingItem = context?.spots![context!.selectedIndex!].parkingItem
            vc.delegate = self
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }
}

extension ParkingResultListViewController: ParkingResultContextObserving {
    public func parkingResultContextDidUpdateResult(_ context: ParkingResultContext) {
        collectionView.reloadData()
    }

    public func parkingResultContextDidChangeSelectedIndex(_ context: ParkingResultContext) {
        guard let index = context.selectedIndex else { return }

        // TODO: Have a bit of the left cell show to indicate scroll direction
        collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .left, animated: true)
        collectionView.reloadData()
    }
}

extension ParkingResultListViewController: ParkingItemCellDelegate {
    public func parkingItemCellDidSelect(_ cell: ParkingItemCellView) {
        performSegue(withIdentifier: "detailsSegue", sender: nil)
    }
}

extension ParkingResultListViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return context?.spots?.count ?? 0
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: parkingCellIdentifier, for: indexPath) as! ParkingItemCellView
        let parkingSpot = context!.spots![indexPath.row]

        cell.topBarView.backgroundColor = context?.selectedIndex == indexPath.row ? cell.tintColor : .gray
        cell.titleLabel.text = parkingSpot.parkingItem.title
        cell.subTitleLabel.text = parkingSpot.parkingItem.subTitle
        cell.totalLabel.text = parkingSpot.parkingItem.price.localizedDescription(in: TravelerUI.preferredCurrency)
        cell.delegate = self

        return cell
    }

    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {

        let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "footer", for: indexPath) as! CollectionSupplementaryView
        let numberOfSpots = context?.spots?.count ?? 0
        if numberOfSpots > 0 {
            footerView.titleLabel.text = "Looking for more Parking?"
            footerView.messageLabel.text = "Move around the map and select \"search this area\"."
        } else {
            footerView.titleLabel.text = "No Parking found"
            footerView.messageLabel.text = "Move around the map and select \"search this area\" to view available Parking options in the area."
        }

        return footerView
    }
}

extension ParkingResultListViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 120, height: collectionView.bounds.height - 10 - ParkingResultMapListViewController.safeAreaBottomInset)
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let numberOfSpots = context?.spots?.count ?? 0
        if numberOfSpots > 0 {
            return CGSize(width: 120, height: collectionView.bounds.height - 10 - ParkingResultMapListViewController.safeAreaBottomInset)
        } else {
            return CGSize(width: collectionView.bounds.width - 14*2, height: collectionView.bounds.height - 10 - ParkingResultMapListViewController.safeAreaBottomInset)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 14, bottom: ParkingResultMapListViewController.safeAreaBottomInset, right: 0)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == context?.selectedIndex {
            performSegue(withIdentifier: "detailsSegue", sender: nil)
        } else {
            context?.selectedIndex = indexPath.row
        }
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        guard let indexPath = collectionView.visibleCells.max(by: {
            let intersect0 = collectionView.bounds.intersection($0.frame)
            let intersect1 = collectionView.bounds.intersection($1.frame)

            return intersect1.width > intersect0.width
        }).flatMap({
            return collectionView.indexPath(for: $0)
        }) else {
            return
        }

        context?.selectedIndex = indexPath.row
    }
}

extension ParkingResultListViewController: ParkingItemDetailViewControllerDelegate {
    public func parkingItemDetailViewController(_ controller: ParkingItemDetailViewController, didFinishWith purchaseForm: PurchaseForm) {
        delegate?.parkingResultListViewController(self, didFinishWith: purchaseForm)
    }
}
