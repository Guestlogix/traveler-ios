//
//  BookingItemQueryViewController.swift
//  TravelerKitUI
//
//  Created by Rakin Hoque on 2019-11-14.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

open class BookingItemQueryViewController: UIViewController {
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var keywordsField: UITextField!
    
    public var query: BookingItemQuery?
    public var categories = BookingItemCategory.allCases
    
    public override func viewDidLoad() {
        cityField.text = query?.city
        keywordsField.text = query?.text
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier, segue.destination) {
        case (_, let vc  as BookingItemQueryCategoryViewController):
            vc.delegate = self
            vc.selectedCategories = query?.categories ?? categories
        case ("bookingItemSearchSegue", let navVC as UINavigationController):
            let vc = navVC.topViewController as? BookingItemSearchViewController
            var filters = BookingItemSearchFilters()
            filters.text = keywordsField.text!
            filters.city = cityField.text!
            filters.categories = categories
            query = query?.filterSearchWith(filters)
            vc?.searchQuery = query
        default:
            Log("Unknown segue", data: segue, level: .warning)
            break
        }
    }
    
    @IBAction func didPressCancel(sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension BookingItemQueryViewController: BookingItemQueryCategoryViewControllerDelegate {
    public func bookingItemQueryCategoryViewController(_ controller: BookingItemQueryCategoryViewController, didFinishWith categories: [BookingItemCategory]) {
        self.categories = categories
    }
}
