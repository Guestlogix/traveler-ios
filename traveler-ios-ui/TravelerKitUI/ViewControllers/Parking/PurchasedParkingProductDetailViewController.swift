//
//  PurchasedParkingProductDetailViewController.swift
//  TravelerKitUI
//
//  Created by Rakin Hoque on 2019-11-29.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit
import MapKit

open class PurchasedParkingProductDetailViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var orderReferenceNumberLabel: UILabel!
    @IBOutlet weak var contactInfoLabel: UILabel!
    @IBOutlet weak var orderDetailLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var priceViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var infoViewHeightConstraint: NSLayoutConstraint!

    public var purchaseDetails: PurchasedParkingProductDetails?

    public override func viewDidLoad() {
        super.viewDidLoad()

        guard let details = purchaseDetails else {
            Log("No ParkingItemDetails/ParkingItem", data: nil, level: .error)
            return
        }
        
        if let location = details.locations.first {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
            mapView.addAnnotation(annotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
            
            addressLabel.text = location.address
        }

        titleLabel.text = details.title
        datesLabel.text = details.datesDescription
        descriptionLabel.attributedText = details.attributedDescription
        
        if let orderReferenceNumber = details.orderReferenceNumber {
            orderReferenceNumberLabel.text = orderReferenceNumber
        }
        
        if let primaryContact = details.primaryContact {
            contactInfoLabel.text = primaryContact
        } else {
            contactInfoLabel.text = "Unavailable"
        }
        
        if let orderDetail = details.orderDetail {
            orderDetailLabel.text = orderDetail
        } else {
            contactInfoLabel.text = "Unavailable"
        }
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as CatalogItemInfoViewController):
            vc.delegate = self
            vc.details = purchaseDetails
        case (_, let vc as ParkingDetailsPriceViewController):
            vc.delegate = self
            vc.totalPrice = purchaseDetails?.price
            vc.onlinePrice = purchaseDetails?.priceToPayOnline
            vc.onsitePrice = purchaseDetails?.priceToPayOnsite
        case (_, let vc as SupplierInfoViewController):
            vc.supplier = purchaseDetails?.supplier
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }
    
    @IBAction func didPressDirectionsButton() {
        guard let location = purchaseDetails?.locations.first, let url = URL(string: "http://maps.apple.com/?q=\(location.latitude),\(location.longitude)") else {
            return
        }

        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension PurchasedParkingProductDetailViewController: ParkingItemDetailsPriceViewControllerDelegate {
    public func parkingDetailsPriceViewControllerDidChangePreferredContentSize(_ controller: ParkingDetailsPriceViewController) {
        priceViewHeightConstraint.constant = controller.preferredContentSize.height
        view.layoutIfNeeded()
    }
}

extension PurchasedParkingProductDetailViewController: CatalogItemInfoViewControllerDelegate {
    public func catalogItemInfoViewControllerDidChangePreferredContentSize(_ controller: CatalogItemInfoViewController) {
        infoView.isHidden = controller.preferredContentSize.height == 0
        infoViewHeightConstraint.constant = controller.preferredContentSize.height
        view.layoutIfNeeded()
    }
}
