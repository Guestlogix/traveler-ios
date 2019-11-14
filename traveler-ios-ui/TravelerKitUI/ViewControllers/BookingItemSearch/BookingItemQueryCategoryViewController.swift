//
//  BookingItemQueryCategoryViewController.swift
//  TravelerKitUI
//
//  Created by Rakin Hoque on 2019-11-15.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

public protocol BookingItemQueryCategoryViewControllerDelegate: class {
    func bookingItemQueryCategoryViewController(_ controller: BookingItemQueryCategoryViewController, didFinishWith categories: [BookingItemCategory])
}

open class BookingItemQueryCategoryViewController: UITableViewController {
    private let categories = BookingItemCategory.allCases
    
    public weak var delegate: BookingItemQueryCategoryViewControllerDelegate?
    
    public var selectedCategories: [BookingItemCategory] = []
    
    public override func viewDidLoad() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifiers.generic)
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
        return categories.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.generic, for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = categories[indexPath.row].rawValue
        
        if selectedCategories.contains(categories[indexPath.row]) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
}
