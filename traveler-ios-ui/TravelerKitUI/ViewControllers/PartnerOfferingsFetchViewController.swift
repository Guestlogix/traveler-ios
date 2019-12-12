//
//  PartnerOfferingsFetchViewController.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-12-01.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

public protocol PartnerOfferingsFetchViewControllerDelegate: class {
    func partnerOfferingsFetchViewController(_ controller: PartnerOfferingsFetchViewController, didFinishWith purchaseForm: PurchaseForm)
}

open class PartnerOfferingsFetchViewController: UIViewController {
    var product: PartnerOfferingItem?
    weak var delegate: PartnerOfferingsFetchViewControllerDelegate?

    private var offerings: [PartnerOfferingGroup]?

    override open func viewDidLoad() {
        super.viewDidLoad()
        guard let product = product else {
            Log("PartnerOfferingsItem is nil", data: nil, level: .warning)
            return
        }

        Traveler.fetchPartnerOfferings(product: product, delegate: self)
    }

    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as OfferingsSelectViewController):
            vc.offeringsGroup = offerings
            vc.product = product
            vc.delegate = self
        case (_, let vc as ErrorViewController):
            vc.delegate = self
            vc.actionButtonString = "Dismiss"
            vc.errorMessageString = "Sorry an error ocurred."
        default:
            Log("Unknown segue", data: nil, level: .warning)
        }
    }
}

extension PartnerOfferingsFetchViewController: FetchPartnerOfferingsDelegate {
    public func fetchOfferingsDidSucceedWith(_ result: [PartnerOfferingGroup]) {
        offerings = result
        performSegue(withIdentifier: "resultSegue", sender: nil)
    }

    public func fetchOfferingsDidFailWith(_ error: Error) {
        performSegue(withIdentifier: "errorSegue", sender: nil)
    }
}

extension PartnerOfferingsFetchViewController: ErrorViewControllerDelegate {
    public func errorViewControllerDidRetry(_ controller: ErrorViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension PartnerOfferingsFetchViewController: OfferingsSelectViewControllerDelegate {
    public func offeringsSelectViewController(_ controller: OfferingsSelectViewController, didFinishWith purchaseForm: PurchaseForm) {
        delegate?.partnerOfferingsFetchViewController(self, didFinishWith: purchaseForm)
    }
}
