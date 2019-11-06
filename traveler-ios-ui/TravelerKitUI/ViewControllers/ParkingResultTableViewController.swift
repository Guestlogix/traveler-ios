//
//  ParkingResultTableViewController.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-10-22.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit

public protocol ParkingResultTableViewControllerDelegate {
    func parkingResultTableViewController(_ controller: ParkingResultTableViewController, didFinishWith purchaseForm: PurchaseForm)
}

public class ParkingResultTableViewController: UITableViewController {
    @IBOutlet weak var countLabel: UILabel!

    public var context: ParkingResultContext?

    public var delegate: ParkingResultTableViewControllerDelegate?

    private var selectedItem: ParkingItem?

    public override func viewDidLoad() {
        super.viewDidLoad()

        context?.addObserver(self)

        updateCountLabel()
    }

    deinit {
        context?.removeObserver(self)
    }

    private func updateCountLabel() {
        switch context?.spots {
        case .some(let spots) where spots.count == 0:
            countLabel.text = "No parking spots found"
        case .some(let spots) where spots.count == 1:
            countLabel.text = "1 Parking spot found"
        case .some(let spots):
            countLabel.text = "\(spots.count) Parking spots found"
        case .none:
            countLabel.text = "Searching for parking spots..."
        }
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as ParkingItemDetailViewController):
            vc.parkingItem = selectedItem
            vc.delegate = self
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    // MARK: UITableViewDataSource

    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return context?.spots?.count ?? 0
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: parkingCellIdentifier, for: indexPath) as! ParkingItemTableViewCell
        let spot = context!.spots![indexPath.row]

        cell.titleLabel.text = spot.parkingItem.title
        cell.subTitleLabel.text = spot.parkingItem.subTitle
        cell.totalLabel.text = spot.parkingItem.price.localizedDescriptionInBaseCurrency

        return cell
    }

    // MARK: UITableViewDelegate

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedItem = context?.spots?[indexPath.row].parkingItem
        performSegue(withIdentifier: "detailSegue", sender: nil)
    }
}

extension ParkingResultTableViewController: ParkingResultContextObserving {
    public func parkingResultContextDidUpdateResult(_ context: ParkingResultContext) {
        tableView.reloadData()
        updateCountLabel()
    }

    public func parkingResultContextDidChangeSelectedIndex(_ context: ParkingResultContext) {
        // noop
    }
}

extension ParkingResultTableViewController: ParkingItemDetailViewControllerDelegate {
    public func parkingItemDetailViewController(_ controller: ParkingItemDetailViewController, didFinishWith purchaseForm: PurchaseForm) {
        delegate?.parkingResultTableViewController(self, didFinishWith: purchaseForm)
    }
}
