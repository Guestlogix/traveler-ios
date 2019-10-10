//
//  TagsCell.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-09-09.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit

public protocol TagsCellDelegate {
    func selectedTags(_ titles: [String])
}

class TagsCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tagsView: TagsView!

    public var delegate: TagsCellDelegate?
    public var tagTitles: [String]? {
        didSet {
            if tagTitles == [] {
                removeTags()
            }
            add(tags: tagTitles!)
        }
    }
    public var selectedTiles: [String]? {
        didSet{
            guard tagTitles != nil else {
                return
            }
            select(tags: selectedTiles!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        tagsView.delegate = self
    }

    private func add(tags: [String]) {
        tagsView.addTags(tags)
    }

    private func select(tags: [String]) {
        tagsView.select(tags)
    }

    private func removeTags() {
        tagsView.removeAllTags()
    }
}

extension TagsCell: TagsViewDelegate {
    func tagPressed(_ title: String?, tag: Tag, sender: TagsView) {
        tag.isSelected = !tag.isSelected
        let selectedTags = sender.selectedTags()
        let tagTitles = selectedTags.map( { $0.currentTitle! })
        delegate?.selectedTags(tagTitles)
    }
}
