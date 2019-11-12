//
//  SearchController.swift
//  TravelerKitUI
//
//  Created by Rakin Hoque on 2019-11-11.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit

public protocol SearchControllerMultipleOptionsDelegate: class {
    func searchController(_ controller: SearchController, didSelect searchOptions: [SearchOption])
}

public protocol SearchControllerSingleOptionDelegate: class {
    func searchController(_ controller: SearchController, didSelect searchOption: SearchOption)
}

open class SearchController: UITableViewController {
    let cellIdentifier = "SearchOptionCell"
    
    public weak var singleSearchDelegate: SearchControllerSingleOptionDelegate?
    public weak var multipleSearchDelegate: SearchControllerMultipleOptionsDelegate?
    
    lazy var doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(multipleOptionsDidSelect))
    lazy var selectedOptions: [String: Bool] = [:]
    
    var currentSearch: String?
    var filteredOptions: [SearchOption] = []
    
    public var options: [SearchOption] = []
    public var searchBarPlaceholder: String?
    
    override public func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = searchBarPlaceholder
        searchController.searchBar.delegate = self

        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true

        if multipleSearchDelegate != nil {
            tableView.allowsMultipleSelection = true
            navigationItem.setRightBarButton(doneButton, animated: false)
        }

        filteredOptions = options
    }
    
    func searchOption(for indexPath: IndexPath) -> SearchOption {
        return filteredOptions[indexPath.row]
    }
    
    @objc func multipleOptionsDidSelect() {
        let options = self.options.filter { selectedOptions[$0.title] ?? false }
        multipleSearchDelegate?.searchController(self, didSelect: options)
    }
    
    func filterOptions(for searchText: String?) {
        guard let searchText = searchText?.lowercased(), searchText.count > 0 else {
            filteredOptions = options
            filteredOptionsDidUpdate()
            return
        }
        
        filteredOptions = options.filter { $0.title.lowercased().contains(searchText) }
        filteredOptionsDidUpdate()
    }
    
    func filteredOptionsDidUpdate() {
        tableView.reloadData()
    }
    
    override open func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredOptions.count
    }
    
    override open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = searchOption(for: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = item.title
        cell.imageView?.image = item.image
        
        if tableView.allowsMultipleSelection && selectedOptions[item.title] ?? false {
            cell.accessoryType = .checkmark
            cell.isSelected = true
        } else {
            cell.accessoryType = .none
            cell.isSelected = false
        }
        
        return cell
    }
    
    override open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView.allowsMultipleSelection {
            let cell = tableView.cellForRow(at: indexPath)
            
            if cell?.accessoryType == .checkmark {
                cell?.accessoryType = .none
                selectedOptions.removeValue(forKey: searchOption(for: indexPath).title)
            } else {
                cell?.accessoryType = .checkmark
                selectedOptions[searchOption(for: indexPath).title] = true
            }
        } else {
            navigationItem.searchController?.isActive = false
            singleSearchDelegate?.searchController(self, didSelect: searchOption(for: indexPath))
        }
    }
}

extension SearchController: UISearchBarDelegate {
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        currentSearch = searchBar.text
        filterOptions(for: searchBar.text)
        navigationItem.searchController?.isActive = false
        searchBar.text = currentSearch
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = currentSearch
    }
}

extension SearchController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        filterOptions(for: searchController.searchBar.text)
    }
}
