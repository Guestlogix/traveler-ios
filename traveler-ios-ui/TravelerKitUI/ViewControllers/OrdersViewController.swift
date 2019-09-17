//
//  OrdersViewController.swift
//  Traveler
//
//  Created by Ata Namvari on 2019-05-06.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

open class OrdersViewController: UIViewController {
    public var query: OrderQuery?

    private var error: Error?
    private var result: OrderResult?

    override open func viewDidLoad() {
        super.viewDidLoad()

        guard let query = query else {
            Log("No OrderQuery", data: nil, level: .error)
            return
        }

        Traveler.fetchOrders(query, identifier: nil, delegate: self)

        performSegue(withIdentifier: "loadingSegue", sender: nil)
    }

    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as OrderResultViewController):
            vc.orderResult = result
        case ("errorSegue", _),
             ("loadingSegue", _):
            break
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }
}

extension OrdersViewController: OrderFetchDelegate {
    public func orderFetchDidSucceedWith(_ result: OrderResult, identifier: AnyHashable?) {
        self.result = result
        
        performSegue(withIdentifier: "resultSegue", sender: nil)
    }

    public func orderFetchDidFailWith(_ error: Error, identifier: AnyHashable?) {
        self.error = error

        performSegue(withIdentifier: "errorSegue", sender: nil)
    }
}
