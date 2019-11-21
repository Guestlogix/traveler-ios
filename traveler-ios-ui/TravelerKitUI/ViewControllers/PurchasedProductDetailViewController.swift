//
//  PurchasedProductDetailViewController.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-05-30.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

open class PurchasedProductDetailViewController: UIViewController {
    public var query: PurchasedProductDetailsQuery?

    override public func viewDidLoad() {
        super.viewDidLoad()
        
        reload()
    }

    override public func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination, sender) {
        case (_, let vc as PurchasedBookingProductDetailViewController, let purchaseDetails as PurchasedBookingProductDetails):
            vc.purchaseDetails = purchaseDetails
        case (_, let vc as PurchasedParkingProductDetailViewController, let purchaseDetails as PurchasedParkingProductDetails):
            vc.purchaseDetails = purchaseDetails
        case (_, let vc as ErrorViewController, _):
            vc.delegate = self
            vc.errorMessageString = "An error occured while loading your product :("
        case ("loadingSegue", _, _):
            break
        default:
            Log("Unknown segue", data: nil, level:.warning)
            break
        }
    }

    func reload() {
        performSegue(withIdentifier: "loadingSegue", sender: nil)
        
        if let query = query {
            Traveler.fetchPurchasedProductDetails(query, delegate: self)
        } else {
            performSegue(withIdentifier: "errorSegue", sender: nil)
        }
    }

    @IBAction func didClose(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension PurchasedProductDetailViewController: PurchasedProductDetailsFetchDelegate {
    public func purchasedProductDetailsFetchDidSucceedWith(_ result: AnyPurchasedProductDetails) {
        switch result.type {
        case .booking:
            let purchasedBookingItemDetails = PurchasedBookingProductDetails(details: result.details as! BookingItemDetails, product: result.product as! PurchasedBookingProduct)
            performSegue(withIdentifier: "purchasedBookingSegue", sender: purchasedBookingItemDetails)
        case .parking:
            let purchasedParkingItemDetails = PurchasedParkingProductDetails(details: result.details as! ParkingItemDetails, product: result.product as! PurchasedParkingProduct)
            performSegue(withIdentifier: "purchasedParkingSegue", sender: purchasedParkingItemDetails)
        case .partnerOffering:
            // TODO: Once UI for purchased partner offering details is available, segue into it
            Log("Unsupported Purchase Type: Partner Offerings", data: nil, level: .warning)
            performSegue(withIdentifier: "errorSegue", sender: nil)
        }
    }
    
    public func purchasedProductDetailsFetchDidFailWith(_ error: Error) {
        performSegue(withIdentifier: "errorSegue", sender: nil)
    }
}

extension PurchasedProductDetailViewController: ErrorViewControllerDelegate {
    public func errorViewControllerDidRetry(_ controller: ErrorViewController) {
        reload()
    }
}
