//
//  CatalogViewController.swift
//  Traveler
//
//  Created by Ata Namvari on 2018-10-25.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import UIKit
import TravelerKit
import TravelerKitUI

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
        case ("errorSegue", let errorVC as ErrorViewController):
            errorVC.delegate = self
        case ("emptySegue", let errorVC as ErrorViewController):
            errorVC.delegate = self
            errorVC.errorTitleString = "Sorry"
            errorVC.errorMessageString = "There's nothing to show :("
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

        if result.groups.count == 0 {
            performSegue(withIdentifier: "emptySegue", sender: nil)
        } else {
            performSegue(withIdentifier: "resultSegue", sender: nil)
        }
    }

    func catalogFetchDidFailWith(_ error: Error) {
        performSegue(withIdentifier: "errorSegue", sender: nil)
    }
}

extension PassengerCatalogViewController: ErrorViewControllerDelegate {
    func errorViewControllerDidRetry(_ controller: ErrorViewController) {
        reload()
    }
}
