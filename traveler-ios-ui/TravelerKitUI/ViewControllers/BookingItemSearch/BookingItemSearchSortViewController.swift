//
//  BookingItemSearchSortViewController.swift
//  TravelerKitUI
//
//  Created by Rakin Hoque on 2019-11-13.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

public protocol BookingItemSearchSortViewControllerDelegate: class {
    func bookingItemSearchSortViewController(_ controller: BookingItemSearchSortViewController, didFinishWith sortOption: ProductItemSort)
}

open class BookingItemSearchSortViewController: UITableViewController {
    @IBOutlet weak var currentLabel: UILabel!
    
    public weak var delegate: BookingItemSearchSortViewControllerDelegate?
    
    public var currentSelection: ProductItemSort = .priceAscending
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: CellIdentifiers.generic)
        
        currentLabel.text = "Current: \(currentSelection.rowInformation.title)"
    }
    
    @IBAction func didCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didApply() {
        delegate?.bookingItemSearchSortViewController(self, didFinishWith: currentSelection)
        dismiss(animated: true, completion: nil)
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let newSelection = ProductItemSort(rawValue: indexPath.row) else {
            return
        }
        
        let previousRow = currentSelection.rowInformation.path
        currentSelection = newSelection
        
        tableView.reloadRows(at: [previousRow, indexPath], with: .none)
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProductItemSort.allCases.count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.generic, for: indexPath)
        let productItemSort = ProductItemSort(rawValue: indexPath.row)
        
        cell.selectionStyle = .none
        cell.textLabel?.text = productItemSort?.rowInformation.title ?? ""
        
        if productItemSort == currentSelection {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
}
