//
//  ParkingQueryViewController.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-10-07.
//  Copyright © 2019 Guestlogix Inc. All rights reserved.
//

import Foundation
import TravelerKit

public protocol ParkingResultMapListViewControllerDelegate: class {
    func parkingResultMapListViewController(_ controller: ParkingResultMapListViewController, didChange boundingBox: BoundingBox)

    func parkingResultMapListViewController(_ controller: ParkingResultMapListViewController, didFinishWith purchaseForm: PurchaseForm)
}

public class ParkingResultMapListViewController: UIViewController {
    @IBOutlet weak var listControllerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var searchButton: UIButton!

    public var context: ParkingResultContext?
    public weak var delegate: ParkingResultMapListViewControllerDelegate?

    private var newBoundingBox: BoundingBox?

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as ParkingResultMapViewController):
            vc.context = context
            vc.delegate = self
            vc.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: listControllerHeightConstraint.constant, right: 0)
        case (_, let vc as ParkingResultListViewController):
            vc.context = context
            vc.delegate = self
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    @IBAction func didSearch(_ sender: Any) {
        guard let newBoundingBox = newBoundingBox else {
            Log("No bounding box", data: nil, level: .error)
            return
        }

        delegate?.parkingResultMapListViewController(self, didChange: newBoundingBox)

        UIView.animate(withDuration: 0.3, animations: {
            self.searchButton.alpha = 0
        }) { _ in
            self.searchButton.isHidden = true
        }
    }
}

extension ParkingResultMapListViewController: ParkingResultMapViewControllerDelegate {
    func parkingResultMapViewController(_ controller: ParkingResultMapViewController, didChange boundingBox: BoundingBox) {
        newBoundingBox = boundingBox

        guard searchButton.isHidden else {
            return
        }

        searchButton.alpha = 0
        searchButton.isHidden = false

        UIView.animate(withDuration: 0.2) { [unowned self] in
            self.searchButton.alpha = 1
        }
    }
}

extension ParkingResultMapListViewController: ParkingResultListViewControllerDelegate {
    public func parkingResultListViewController(_ controller: ParkingResultListViewController, didFinishWith purchaseForm: PurchaseForm) {
        delegate?.parkingResultMapListViewController(self, didFinishWith: purchaseForm)
    }
}
