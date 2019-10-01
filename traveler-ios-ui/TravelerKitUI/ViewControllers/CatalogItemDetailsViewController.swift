//
//  CatalogItemDetailsViewController.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-07.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import UIKit
import TravelerKit

class CatalogItemDetailsViewController: UIViewController {

    var itemDetails: CatalogItemDetails?

    override func viewDidLoad() {
        super.viewDidLoad()

        switch itemDetails {
        case let itemDetails as BookingItemDetails:
            performSegue(withIdentifier: "bookingSegue", sender: itemDetails)
        default:
            Log("Unknown item type", data: nil, level: .error)
            performSegue(withIdentifier: "errorSegue", sender: nil)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination, sender) {
        case (_, let vc as BookingItemDetailsViewController , let sender as BookingItemDetails):
            vc.bookingItemDetails = sender
        default:
            performSegue(withIdentifier: "errorSegue", sender: nil)
        }
    }

}
