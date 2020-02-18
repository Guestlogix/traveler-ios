//
//  BookingItemCategoryFetchViewController.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2020-02-18.
//  Copyright © 2020 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

public protocol BookingItemCategoryFetchViewControllerDelegate {
    func categoryFetchDidFailWith(_ error: Error)
    func categoryFetchIsLoading(_ controller: BookingItemCategoryFetchViewController)
}

extension BookingItemCategoryFetchViewControllerDelegate {
    func categoryFetchIsLoading(_ controller: BookingItemCategoryFetchViewController) {
        //No-op
    }
}

open class BookingItemCategoryFetchViewController: UIViewController {

    public var query: BookingItemQuery?
    private var selectedCategories: [BookingItemCategory]?
    private var delegate: BookingItemCategoryFetchViewControllerDelegate?

    override open func viewDidLoad() {
        super.viewDidLoad()

        if query?.categories.count != 0 {
            performSegue(withIdentifier: "categoryResult", sender: nil)
        } else {
            Traveler.fetchBookingItemCategories(delegate: self)
            delegate?.categoryFetchIsLoading(self)
            performSegue(withIdentifier: "loadingSegue", sender: nil)
        }
    }

    open override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch(segue.identifier, segue.destination) {
        case (_, let vc as BookingItemQueryCategoryViewController):
            vc.categories = query?.categories ?? selectedCategories
        default:
            Log("Unknown segue", data: nil, level: .warning)
        }
    }
}

extension BookingItemCategoryFetchViewController: BookingItemCategoryFetchDelegate {
    public func bookingItemCategoryFetchDidSuccedWith(_ result: [BookingItemCategory]) {
        selectedCategories = result
        performSegue(withIdentifier: "categoryResult", sender: nil)
    }

    public func bookingItemCategoryFetchDidFailWith(_ error: Error) {
        delegate?.categoryFetchDidFailWith(error)
    }
}


