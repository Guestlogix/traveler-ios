//
//  SimilarItemsViewController.swift
//  TravelerKitUI
//
//  Created by Rakin Hoque on 2019-11-01.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

public protocol SimilarItemsViewControllerDelegate: class {
    func similarItemsViewController(_ controller: SimilarItemsViewController, didFailWith: Error)
}

open class SimilarItemsViewController: UIViewController {
    var product: Product?

    private var catalog: Catalog?
    
    weak var delegate: SimilarItemsViewControllerDelegate?

    override open func viewDidLoad() {
        super.viewDidLoad()
        reload()
    }

    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case ("loadingSegue"?, _):
            break
        case (_, let resultVC as SimilarItemsResultViewController):
            resultVC.catalog = catalog
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }

    private func reload() {
        guard let product = product else {
            Log("No Product", data: nil, level: .error)
            return
        }

        performSegue(withIdentifier: "loadingSegue", sender: nil)
        Traveler.fetchSimilarProducts(to: product, delegate: self)
    }
}

extension SimilarItemsViewController: SimilarProductsFetchDelegate {
    public func similarItemsFetchDidSucceedWith(_ result: Catalog) {
        guard let group = result.groups.first, group.items.count > 0 else {
            return
        }
        
        self.catalog = result
        performSegue(withIdentifier: "resultSegue", sender: nil)
    }
    
    public func similarItemsFetchDidFailWith(_ error: Error) {
        self.delegate?.similarItemsViewController(self, didFailWith: error)
    }
}
