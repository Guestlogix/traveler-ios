//
//  CatalogViewController.swift
//  Passenger
//
//  Created by Ata Namvari on 2018-10-25.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import UIKit
import TravelerKit

class PassengerCatalogViewController: UIViewController {
    var query: CatalogQuery?

    private var catalog: Catalog?

    override func viewDidLoad() {
        super.viewDidLoad()

        reload()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case ("loadingSegue"?, _):
            break
        case (_, let retryVC as RetryViewController):
            retryVC.delegate = self
        case (_, let resultVC as PassengerCatalogResultViewController):
            resultVC.catalog = catalog
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    private func reload() {
        guard let query = query else {
            Log("No CatalogQuery", data: nil, level: .error)
            return
        }

        performSegue(withIdentifier: "loadingSegue", sender: nil)

        Traveler.fetchCatalog(query: query, delegate: self)
    }
}

extension PassengerCatalogViewController: CatalogFetchDelegate {
    func catalogFetchDidSucceedWith(_ result: Catalog) {
        self.catalog = result

        performSegue(withIdentifier: "resultSegue", sender: nil)
    }

    func catalogFetchDidFailWith(_ error: Error) {
        performSegue(withIdentifier: "errorSegue", sender: nil)
    }
}

extension PassengerCatalogViewController: RetryViewControllerDelegate {
    func retryViewControllerDidRetry(_ controller: RetryViewController) {
        reload()
    }
}
