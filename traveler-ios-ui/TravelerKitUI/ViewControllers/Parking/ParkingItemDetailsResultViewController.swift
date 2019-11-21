//
//  ParkingItemDetailsResultViewController.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-10-22.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit
import MapKit

public protocol ParkingItemDetailsResultViewControllerDelegate: class {
    func parkingItemDetailsResultViewController(_ controller: ParkingItemDetailsResultViewController, didFinishWith purchaseForm: PurchaseForm)
}

public class ParkingItemDetailsResultViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var priceViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var itemInfoHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var itemInfoView: UIView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!

    public var details: ParkingItemDetails?
    // TODO: Have the backend include coordinate and other information so this property doesn't
    // need to be passed around
    // TODO: ParkingItemDetails should also include the dates
    public var parkingItem: ParkingItem?

    var parkingForm: PurchaseForm?
    weak var delegate: ParkingItemDetailsResultViewControllerDelegate?

    public override func viewDidLoad() {
        super.viewDidLoad()
        mapView.register(LabeledAnnotationView.self, forAnnotationViewWithReuseIdentifier: parkingAnnotationIdentifier)

        guard let details = details, let parkingItem = parkingItem else {
            Log("No ParkingItemDetails/ParkingItem", data: nil, level: .error)
            return
        }

        let parkingSpot = ParkingSpot(parkingItem: parkingItem)

        mapView.addAnnotation(parkingSpot)
        mapView.showAnnotations([parkingSpot], animated: true)

        titleLabel.text = details.title
        addressLabel.text = details.locations.first?.address
        datesLabel.text = details.datesDescription

        descriptionLabel.attributedText = details.attributedDescription
        totalPriceLabel.text = details.priceToPayOnline.localizedDescriptionInBaseCurrency
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as CatalogItemInfoViewController):
            vc.delegate = self
            vc.details = details
        case (_, let vc as ParkingDetailsPriceViewController):
            vc.delegate = self
            vc.totalPrice = details?.price
            vc.onlinePrice = details?.priceToPayOnline
            vc.onsitePrice = details?.priceToPayOnsite
        case (_, let vc as SupplierInfoViewController):
            vc.supplier = details?.supplier
        case (_, let vc as PurchaseQuestionsViewController):
            vc.delegate = self
            vc.purchaseForm = parkingForm
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    @IBAction func didContinue(_ sender: Any) {
        guard let product = parkingItem else {
            Log("No product", data: nil, level: .error)
            return
        }

        checkoutButton.isEnabled = false

        Traveler.fetchPurchaseForm(product: product, delegate: self)
    }
}

extension ParkingItemDetailsResultViewController: MKMapViewDelegate {
    public func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let _ = annotation as? ParkingSpot else {
            Log("MapAnnotation not a ParkingSpot", data: nil, level: .error)
            return nil
        }

        let view = mapView.dequeueReusableAnnotationView(withIdentifier: parkingAnnotationIdentifier, for: annotation) as! LabeledAnnotationView

        view.annotation = annotation
        view.isChosen = true

        return view
    }
}

extension ParkingItemDetailsResultViewController: ParkingItemDetailsPriceViewControllerDelegate {
    public func parkingDetailsPriceViewControllerDidChangePreferredContentSize(_ controller: ParkingDetailsPriceViewController) {
        priceViewHeightConstraint.constant = controller.preferredContentSize.height
        view.layoutIfNeeded()
    }
}

extension ParkingItemDetailsResultViewController: CatalogItemInfoViewControllerDelegate {
    public func catalogItemInfoViewControllerDidChangePreferredContentSize(_ controller: CatalogItemInfoViewController) {
        itemInfoView.isHidden = controller.preferredContentSize.height == 0
        itemInfoHeightConstraint.constant = controller.preferredContentSize.height
        view.layoutIfNeeded()
    }
}

extension ParkingItemDetailsResultViewController: PurchaseFormFetchDelegate {
    public func purchaseFormFetchDidFailWith(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)

        alert.addAction(okAction)

        present(alert, animated: true)

        checkoutButton.isEnabled = false
    }

    public func purchaseFormFetchDidSucceedWith(_ purchaseForm: PurchaseForm) {
        self.parkingForm = purchaseForm

        checkoutButton.isEnabled = true

        performSegue(withIdentifier: "questionsSegue", sender: nil)
    }
}

extension ParkingItemDetailsResultViewController: PurchaseQuestionsViewControllerDelegate {
    public func purchaseQuestionsViewController(_ controller: PurchaseQuestionsViewController, didCheckoutWith purchaseForm: PurchaseForm) {
        delegate?.parkingItemDetailsResultViewController(self, didFinishWith: purchaseForm)
    }
}
