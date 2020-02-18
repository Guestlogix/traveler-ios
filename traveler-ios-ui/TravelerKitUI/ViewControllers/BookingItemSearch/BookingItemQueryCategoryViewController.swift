//
//  BookingItemQueryCategoryViewController.swift
//  TravelerKitUI
//
//  Created by Rakin Hoque on 2019-11-15.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

/*
 Note: SDK UI layer is in the process of being refactored and it is Guestlogix' decision to shelve the UI layer of the SDK for the moment. As such, this view controller's implementation is neither complete nor correct. I should not be used in production.
 */

public protocol BookingItemQueryCategoryViewControllerDelegate: class {
    func bookingItemQueryCategoryViewController(_ controller: BookingItemQueryCategoryViewController, didFinishWith categories: [BookingItemCategory])
}

open class BookingItemQueryCategoryViewController: UITableViewController {
    public var categories: [BookingItemCategory]?
    private var selectedCategories = [BookingItemCategory]()
    
    public weak var delegate: BookingItemQueryCategoryViewControllerDelegate?
    
    public override func viewDidLoad() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifiers.generic)
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let categories = categories else {
            return
        }

        if let index = selectedCategories.index(of: categories[indexPath.row]) {
            selectedCategories.remove(at: index)
        } else {
            selectedCategories.append(categories[indexPath.row])
        }
        
        tableView.reloadRows(at: [indexPath], with: .none)
        
        delegate?.bookingItemQueryCategoryViewController(self, didFinishWith: selectedCategories)
    }
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.generic, for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = categories?[indexPath.row].title
        
        if selectedCategories.contains(categories![indexPath.row]) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
}
