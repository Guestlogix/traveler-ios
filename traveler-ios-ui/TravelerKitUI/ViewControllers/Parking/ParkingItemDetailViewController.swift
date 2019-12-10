//
//  ParkingItemDetailViewController.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-10-22.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit

public protocol ParkingItemDetailViewControllerDelegate: class {
    func parkingItemDetailViewController(_ controller: ParkingItemDetailViewController, didFinishWith purchaseForm: PurchaseForm)
}

public class ParkingItemDetailViewController: UIViewController {
    public var parkingItem: ParkingItem?

    weak var delegate: ParkingItemDetailViewControllerDelegate?

    private var details: ParkingItemDetails?

    public override func viewDidLoad() {
        super.viewDidLoad()

        reload()
    }

    private func reload() {
        guard let item = parkingItem else {
            Log("No ParkingItem", data: nil, level: .error)
            return
        }

        performSegue(withIdentifier: "loadingSegue", sender: nil)

        Traveler.fetchProductDetails(item, delegate: self)
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case ("loadingSegue"?, _):
            break
        case (_, let vc as ErrorViewController):
            vc.delegate = self
            vc.errorMessageString = "Error loading parking details"
        case (_, let vc as ParkingItemDetailsResultViewController):
            vc.details = details
            vc.parkingItem = parkingItem
            vc.delegate = self
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }
}

extension ParkingItemDetailViewController: CatalogItemDetailsFetchDelegate {
    public func catalogItemDetailsFetchDidSucceedWith(_ result: CatalogItemDetails) {
        guard let details = result as? ParkingItemDetails else {
            Log("Unexpected type", data: type(of: result), level: .error)
            return
        }

        self.details = details

        performSegue(withIdentifier: "resultSegue", sender: nil)
    }

    public func catalogItemDetailsFetchDidFailWith(_ error: Error) {
        // TODO: Pass specific error for cases where the parking spot ahs expired

        performSegue(withIdentifier: "errorSegue", sender: nil)
    }
}

extension ParkingItemDetailViewController: ErrorViewControllerDelegate {
    public func errorViewControllerDidRetry(_ controller: ErrorViewController) {
        reload()
    }
}

extension ParkingItemDetailViewController: ParkingItemDetailsResultViewControllerDelegate {
    public func parkingItemDetailsResultViewController(_ controller: ParkingItemDetailsResultViewController, didFinishWith purchaseForm: PurchaseForm) {
        delegate?.parkingItemDetailViewController(self, didFinishWith: purchaseForm)
    }
}
