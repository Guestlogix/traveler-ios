//
//  SectionedSearchController.swift
//  TravelerKitUI
//
//  Created by Rakin Hoque on 2019-11-11.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit

open class SectionedSearchController: SearchController {
    var sections: [String] = []
    var sectionedOptions: [String: [SearchOption]] = [:]
    
    public var showSectionHeaders: Bool = false
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        updateSections()
    }
    
    func updateSections() {
        sections = Array(Set(filteredOptions.map { String($0.title.first!) })).sorted()
        
        for section in sections {
            sectionedOptions[section] = Array(filteredOptions.filter { String($0.title.first!) == section }).sorted(by: {$0.title < $1.title})
        }
    }
    
    override func filteredOptionsDidUpdate() {
        updateSections()
        tableView.reloadData()
    }
    
    override func searchOption(for indexPath: IndexPath) -> SearchOption {
        return sectionedOptions[sections[indexPath.section]]?[indexPath.row] ?? SearchOption("")
    }
    
    override open func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    override open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard showSectionHeaders && section < sections.count else {
            return nil
        }

        return sections[section]
    }
    
    override open func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return sections
    }
    
    override open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard section < sections.count else {
            return 0
        }
        
        return sectionedOptions[sections[section]]?.count ?? 0
    }
}
