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

open class ParkingResultMapListViewController: UIViewController {
    static let searchButtonBottomSpacing: CGFloat = 13
    static let listControllerContentHeight: CGFloat = 170
    static let safeAreaBottomInset: CGFloat = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    static let listControllerHeight: CGFloat = listControllerContentHeight + safeAreaBottomInset

    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var searchButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var listControllerHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var listControllerBottomConstraint: NSLayoutConstraint!

    public var context: ParkingResultContext?
    public weak var delegate: ParkingResultMapListViewControllerDelegate?

    private var newBoundingBox: BoundingBox?

    override open func viewDidLoad() {
        context?.addObserver(self)

        searchButton.setTitle("  Search this area", for: .normal)
        if #available(iOS 13.0, *) {
            searchButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        }
        searchButton.setTitle("  Loading...", for: .disabled)
        if #available(iOS 13.0, *) {
            searchButton.setImage(UIImage(systemName: "slowmo"), for: .disabled)
        }

        listControllerHeightConstraint.constant = ParkingResultMapListViewController.listControllerHeight
        updateListController()
    }

    private func updateListController() {
        switch context?.result {
        case .some:
            searchButton.isEnabled = true
            searchButton.alpha = 0
            searchButton.isHidden = true

            UIView.animate(withDuration: 0.3, animations: {
                self.searchButtonBottomConstraint.constant = ParkingResultMapListViewController.searchButtonBottomSpacing
                self.listControllerBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        case .none:
            searchButton.isEnabled = false
            searchButton.alpha = 1
            searchButton.isHidden = false

            UIView.animate(withDuration: 0.3, animations: {
                self.searchButtonBottomConstraint.constant = ParkingResultMapListViewController.searchButtonBottomSpacing + ParkingResultMapListViewController.safeAreaBottomInset
                self.listControllerBottomConstraint.constant = ParkingResultMapListViewController.listControllerHeight
                self.view.layoutIfNeeded()
            })
        }
    }

    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as ParkingResultMapViewController):
            vc.context = context
            vc.delegate = self
            vc.additionalSafeAreaInsets = UIEdgeInsets(top: 0, left: 0, bottom: ParkingResultMapListViewController.listControllerContentHeight, right: 0)
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
    }
}

extension ParkingResultMapListViewController: ParkingResultContextObserving {
    public func parkingResultContextDidUpdateResult(_ context: ParkingResultContext) {
        updateListController()
    }

    public func parkingResultContextDidChangeSelectedIndex(_ context: ParkingResultContext) {
        // noop
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
