//
//  WishlistViewController.swift
//  TravelerKitUI
//
//  Created by Ben Ruan on 2019-09-04.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

open class WishlistViewController: UIViewController {
    public var query: WishlistQuery?
    private var error: Error?
    private var result: WishlistResult?

    override open func viewDidLoad() {
        super.viewDidLoad()

        reload()
    }

    private func reload() {
        guard let query = query else {
            Log("No WishlistQuery", data: nil, level: .error)
            return
        }

        self.performSegue(withIdentifier: "loadingSegue", sender: nil)
        Traveler.fetchWishlist(query, identifier: nil, delegate: self)
    }
    
    override open func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc as WishlistResultViewController):
            vc.wishlistResult = result
            vc.delegate = self
        case ("emptySegue", let vc as ErrorViewController):
            vc.errorMessageString = "There are currently no saved items to show"
        case ("errorSegue", let vc as ErrorViewController):
            vc.delegate = self
            vc.errorMessageString = "An error occured while loading your wishlist :("
        case ("loadingSegue", _):
            break
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }
}

extension WishlistViewController: WishlistFetchDelegate {
    public func wishlistFetchDidSucceedWith(_ result: WishlistResult, identifier: AnyHashable?) {
        self.result = result
        if result.total > 0 {
            performSegue(withIdentifier: "resultSegue", sender: nil)
        } else {
            performSegue(withIdentifier: "emptySegue", sender: nil)
        }
    }

    public func wishlistFetchDidFailWith(_ error: Error, identifier: AnyHashable?) {
        self.error = error

        performSegue(withIdentifier: "errorSegue", sender: nil)
    }
}

extension WishlistViewController: ErrorViewControllerDelegate {
    public func errorViewControllerDidRetry(_ controller: ErrorViewController) {
        reload()
    }
}

extension WishlistViewController: WishlistResultViewControllerDelegate {
    public func wishlistResultViewControllerDidRefresh(_ controller: WishlistResultViewController) {
        reload()
    }
}
