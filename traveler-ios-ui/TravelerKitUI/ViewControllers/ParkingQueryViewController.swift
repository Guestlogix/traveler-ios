//
//  ParkingQueryViewController.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-10-22.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit

public protocol ParkingQueryViewControllerDelegate {
    func parkingQueryViewController(_ controller: ParkingQueryViewController, didFinishWith purchaseForm: PurchaseForm)
}

public class ParkingQueryViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var datesLabel: UILabel!
    @IBOutlet weak var mapContainerView: UIView!
    @IBOutlet weak var listContainerView: UIView!
    @IBOutlet weak var topOverlayHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var segmentContainerView: UIView!

    public var query: ParkingItemQuery? 

    public var delegate: ParkingQueryViewControllerDelegate?

    private let context = ParkingResultContext()
    private var _parkingSpots: [ParkingSpot] = []

    public override func viewDidLoad() {
        super.viewDidLoad()

        performSegue(withIdentifier: "mapSegue", sender: nil)
        performSegue(withIdentifier: "listSegue", sender: nil)

        reloadQuery()
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue, segue.destination) {
        case (let segue as ContainerEmbedSegue, let vc as ParkingResultMapListViewController):
            segue.containerView = mapContainerView
            vc.context = context
            vc.delegate = self
            vc.additionalSafeAreaInsets = UIEdgeInsets(top: segmentContainerView.frame.height, left: 0, bottom: 0, right: 0)
        case (let segue as ContainerEmbedSegue, let vc as ParkingResultTableViewController):
            segue.containerView = listContainerView
            vc.context = context
            vc.additionalSafeAreaInsets = UIEdgeInsets(top: topOverlayHeightConstraint.constant, left: 0, bottom: 0, right: 0)
            vc.delegate = self
        case (_, let vc as ParkingQueryChangeViewController):
            vc.query = query
            vc.delegate = self
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    @IBAction func didChangeView(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            mapContainerView.isHidden = false
            listContainerView.isHidden = true
            segmentContainerView.alpha = 0
        case 1:
            mapContainerView.isHidden = true
            listContainerView.isHidden = false
            segmentContainerView.alpha = 1
        default:
            Log("Unknown view", data: sender.selectedSegmentIndex, level: .error)
            break
        }
    }

    private func reloadQuery() {
        guard let query = query else {
            Log("No Query", data: nil, level: .error)
            return
        }

        datesLabel.text = query.datesDescription
        titleLabel.text = query.airportIATA == nil ? "Parking near you" : "Parking near \(query.airportIATA!.uppercased())"

        activityIndicator.startAnimating()

        Traveler.searchParkingItems(query, identifier: nil, delegate: self)
    }
}

extension ParkingQueryViewController: ParkingItemSearchDelegate {
    public func parkingItemSearchDidFailWith(_ error: Error, identifier: AnyHashable?) {
        activityIndicator.stopAnimating()

        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default, handler: nil)

        alert.addAction(action)

        present(alert, animated: true, completion: nil)
    }

    public func parkingItemSearchDidReceive(_ result: ParkingItemSearchResult, identifier: AnyHashable?) {
        context.result = result
    }

    public func parkingItemSearchDidSucceedWith(_ result: ParkingItemSearchResult, identifier: AnyHashable?) {
        activityIndicator.stopAnimating()
    }
}

extension ParkingQueryViewController: ParkingResultMapListViewControllerDelegate {
    public func parkingResultMapListViewController(_ controller: ParkingResultMapListViewController, didFinishWith purchaseForm: PurchaseForm) {
        delegate?.parkingQueryViewController(self, didFinishWith: purchaseForm)
    }

    public func parkingResultMapListViewController(_ controller: ParkingResultMapListViewController, didChange boundingBox: BoundingBox) {
        query?.boundingBox = boundingBox
        query?.airportIATA = nil

        reloadQuery()
    }
}

//extension ParkingQueryViewController: ParkingQueryFormViewControllerDelegate {
//    public func parkingQueryFormViewController(_ controller: ParkingQueryFormViewController, didUpdate query: ParkingItemQuery) {
//        self.query = query
//
//        navigationController?.popViewController(animated: true)
//
//        reloadQuery()
//    }
//}

extension ParkingQueryViewController: ParkingResultTableViewControllerDelegate {
    public func parkingResultTableViewController(_ controller: ParkingResultTableViewController, didFinishWith purchaseForm: PurchaseForm) {
        delegate?.parkingQueryViewController(self, didFinishWith: purchaseForm)
    }
}

extension ParkingQueryViewController: ParkingQueryChangeViewControllerDelegate {
    func parkingQueryChangeViewController(_ controller: ParkingQueryChangeViewController, didUpdate query: ParkingItemQuery) {
        self.query = query
        navigationController?.popViewController(animated: true)
        reloadQuery()
    }
}
