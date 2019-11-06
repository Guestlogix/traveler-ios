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

public protocol ParkingResultListViewControllerDelegate {
    func parkingResultListViewController(_ controller: ParkingResultListViewController, didFinishWith purchaseForm: PurchaseForm)
}

public class ParkingResultListViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!

    public var context: ParkingResultContext?
    public var delegate: ParkingResultListViewControllerDelegate?

    override public func viewDidLoad() {
        super.viewDidLoad()

        context?.addObserver(self)

        collectionView.decelerationRate = .fast
    }

    deinit {
        context?.removeObserver(self)
    }

    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
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

        cell.topBarView.backgroundColor = context?.selectedIndex == indexPath.row ? .blue : .gray
        cell.titleLabel.text = parkingSpot.parkingItem.title
        cell.subTitleLabel.text = parkingSpot.parkingItem.subTitle
        cell.totalLabel.text = parkingSpot.parkingItem.price.localizedDescription(in: TravelerUI.preferredCurrency)

        return cell
    }
}

extension ParkingResultListViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 60, height: collectionView.bounds.height - 10)
    }

    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

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
        collectionView.reloadData()
    }
}

extension ParkingResultListViewController: ParkingItemDetailViewControllerDelegate {
    public func parkingItemDetailViewController(_ controller: ParkingItemDetailViewController, didFinishWith purchaseForm: PurchaseForm) {
        delegate?.parkingResultListViewController(self, didFinishWith: purchaseForm)
    }
}
