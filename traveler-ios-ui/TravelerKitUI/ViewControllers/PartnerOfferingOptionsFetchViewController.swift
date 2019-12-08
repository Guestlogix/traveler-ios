//
//  PartnerOfferingOptionsFetchViewController.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-12-01.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

public protocol PartnerOfferingOptionsFetchViewControllerDelegate: class {
    func partnerOfferingOptionsFetchViewController(_ controller: PartnerOfferingOptionsFetchViewController, didFinishWith purchaseForm: PurchaseForm)
}

open class PartnerOfferingOptionsFetchViewController: UIViewController {

    var product: PartnerOfferingItem?
    weak var delegate: PartnerOfferingOptionsFetchViewControllerDelegate?

    private var offerings: [PartnerOfferingGroup]?

    override open func viewDidLoad() {
        super.viewDidLoad()
        guard let product = product else {
            Log("PartnerOfferingsItem is nil", data: nil, level: .warning)
            return
        }

        Traveler.fetchOfferings(product: product, delegate: self)

    }

    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as OptionsSelectViewController):
            vc.optionsGroup = offerings
            vc.product = product
            vc.delegate = self
        case (_, let vc as ErrorViewController):
            vc.delegate = self
            vc.retryButtonString = "Dismiss"
            vc.errorMessageString = "Sorry an error ocurred."
        default:
            Log("Unknown segue", data: nil, level: .warning)
        }
    }
}

extension PartnerOfferingOptionsFetchViewController: FetchOfferingsDelegate {
    public func fetchOfferingsDidSucceedWith(_ result: [PartnerOfferingGroup]) {
        offerings = result
        performSegue(withIdentifier: "resultSegue", sender: nil)
    }

    public func fetchOfferingsDidFailWith(_ error: Error) {
        performSegue(withIdentifier: "errorSegue", sender: nil)
    }
}

extension PartnerOfferingOptionsFetchViewController: ErrorViewControllerDelegate {
    public func errorViewControllerDidRetry(_ controller: ErrorViewController) {
        dismiss(animated: true, completion: nil)
    }
}

extension PartnerOfferingOptionsFetchViewController: OptionsSelectViewControllerDelegate {
    public func optionsSelectViewController(_ controller: OptionsSelectViewController, didFinishWith purchaseForm: PurchaseForm) {
        delegate?.partnerOfferingOptionsFetchViewController(self, didFinishWith: purchaseForm)
    }
}
