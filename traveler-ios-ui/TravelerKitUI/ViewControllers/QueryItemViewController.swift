//
//  QueryItemViewController.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-10-07.
//  Copyright © 2019 Guestlogix Inc. All rights reserved.
//

import Foundation
import TravelerKit

public protocol QueryItemViewControllerDelegate: class {
    func queryItemViewController(_ controller: QueryItemViewController, didFinishWith purchaseForm: PurchaseForm)
}

public class QueryItemViewController: UIViewController {
    public var queryItem: QueryItem?

    public weak var delegate: QueryItemViewControllerDelegate?

    public override func viewDidLoad() {
        super.viewDidLoad()

        switch queryItem?.query {
        case .some(.booking(let bookingQuery)):
            performSegue(withIdentifier: "bookingSegue", sender: bookingQuery)
        case .some(.parking(let parkingQuery)):
            performSegue(withIdentifier: "parkingSegue", sender: parkingQuery)
        case .none:
            Log("No QueryItem", data: nil, level: .error)
            break
        }
    }

    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination, sender) {
        case (_, let vc as BookingItemQueryViewController, let query as BookingItemQuery):
            //vc.searchQuery = query
            // TODO: Reusable loading state for BookingItemQueryViewController
            break
        case (_, let vc as ParkingQueryViewController, let query as ParkingItemQuery):
            vc.query = query
            vc.delegate = self
            break
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }
}

extension QueryItemViewController: ParkingQueryViewControllerDelegate {
    public func parkingQueryViewController(_ controller: ParkingQueryViewController, didFinishWith purchaseForm: PurchaseForm) {
        delegate?.queryItemViewController(self, didFinishWith: purchaseForm)
    }
}
