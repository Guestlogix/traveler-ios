//
//  CatalogQueryViewController.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-12-05.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit

protocol CatalogQueryViewControllerDelegate: class {
    func catalogQueryViewControllerDidChangePreferredContentSize(_ controller: CatalogQueryViewController)
}

open class CatalogQueryViewController: UIViewController {
    var query: CatalogQuery?
    weak var delegate: CatalogQueryViewControllerDelegate?

    private var catalog: Catalog?

    open override func viewDidLoad() {
        super.viewDidLoad()

        reload()
    }

    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case ("loadingSegue", _),
             ("errorSegue", _):
            break
        case (_, let vc as CatalogResultViewController):
            vc.catalog = catalog
            vc.delegate = self
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

extension CatalogQueryViewController: CatalogFetchDelegate {
    public func catalogFetchDidSucceedWith(_ result: Catalog) {
        self.catalog = result

        performSegue(withIdentifier: "resultSegue", sender: nil)
    }

    public func catalogFetchDidFailWith(_ error: Error) {
        performSegue(withIdentifier: "errorSegue", sender: nil)

        preferredContentSize = CGSize.zero

        delegate?.catalogQueryViewControllerDidChangePreferredContentSize(self)
    }
}

extension CatalogQueryViewController: CatalogResultViewControllerDelegate {
    public func catalogResultViewControllerDidChangePreferredContentSize(_ controller: CatalogResultViewController) {
        self.preferredContentSize = controller.preferredContentSize

        delegate?.catalogQueryViewControllerDidChangePreferredContentSize(self)
    }
}
