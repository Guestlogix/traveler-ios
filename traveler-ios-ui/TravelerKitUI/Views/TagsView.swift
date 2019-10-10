//
//  TagsView.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-09-09.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

/*
 Modified from https://github.com/ElaWorkshop/TagListView
 */

import UIKit

@objc public protocol TagsViewDelegate {
    func tagPressed(_ title: String?, tag: Tag, sender: TagsView) -> Void
}

@IBDesignable
open class TagsView: UIView {

    @IBInspectable open dynamic var textColor: UIColor = .white {
        didSet {
            tags.forEach {
                $0.textColor = textColor
            }
        }
    }

    @IBInspectable open dynamic var selectedTextColor: UIColor = .white {
        didSet {
            tags.forEach {
                $0.selectedTextColor = selectedTextColor
            }
        }
    }

    @IBInspectable open dynamic var tagLineBreakMode: NSLineBreakMode = .byTruncatingMiddle {
        didSet {
            tags.forEach {
                $0.titleLineBreakMode = tagLineBreakMode
            }
        }
    }

    @IBInspectable open dynamic var tagBackgroundColor: UIColor = UIColor.gray {
        didSet {
            tags.forEach {
                $0.tagBackgroundColor = tagBackgroundColor
            }
        }
    }

    @IBInspectable open dynamic var tagSelectedBackgroundColor: UIColor? {
        didSet {
            tags.forEach {
                $0.selectedBackgroundColor = tagSelectedBackgroundColor
            }
        }
    }

    @IBInspectable open dynamic var cornerRadius: CGFloat = 0 {
        didSet {
            tags.forEach {
                $0.cornerRadius = cornerRadius
            }
        }
    }

    @IBInspectable open dynamic var paddingY: CGFloat = 2 {
        didSet {
            defer { refreshView() }
            tags.forEach {
                $0.paddingY = paddingY
            }
        }
    }
    @IBInspectable open dynamic var paddingX: CGFloat = 5 {
        didSet {
            defer { refreshView() }
            tags.forEach {
                $0.paddingX = paddingX
            }
        }
    }
    @IBInspectable open dynamic var marginY: CGFloat = 2 {
        didSet {
            refreshView()
        }
    }
    @IBInspectable open dynamic var marginX: CGFloat = 5 {
        didSet {
            refreshView()
        }
    }

   @IBInspectable @objc open dynamic var textFont: UIFont = .systemFont(ofSize: 15) {
        didSet {
            defer { refreshView() }
            tags.forEach {
                $0.textFont = textFont
            }
        }
    }

    override open var intrinsicContentSize: CGSize {
        var height = CGFloat(rows) * (tagViewHeight + marginY)
        if rows > 0 {
            height -= marginY
        }
        return CGSize(width: frame.width, height: height)
    }

    @IBOutlet open weak var delegate: TagsViewDelegate?

    open private(set) var tags: [Tag] = []
    private(set) var rowViews: [UIView] = []
    private(set) var tagViewHeight: CGFloat = 0
    private(set) var rows = 0 {
        didSet {
            invalidateIntrinsicContentSize()
        }
    }

    // MARK: - Interface Builder

    open override func prepareForInterfaceBuilder() {
        addTag("Sample tag 1")
        addTag("Sample tag 2")
        addTag("Selected Sample Tag").isSelected = true
    }

    // MARK: - Layout

    open override func layoutSubviews() {
        defer { refreshView() }
        super.layoutSubviews()
    }

    private func refreshView() {
        let views = tags as [UIView] + rowViews
        views.forEach {
            $0.removeFromSuperview()
        }
        rowViews.removeAll(keepingCapacity: true)

        var currentRow = 0
        var currentRowView: UIView!
        var currentRowTagCount = 0
        var currentRowWidth: CGFloat = 0

        for tag in tags {
            tag.frame.size = tag.intrinsicContentSize
            tagViewHeight = tag.frame.height

            if currentRowTagCount == 0 || currentRowWidth + tag.frame.width > frame.width {
                currentRow += 1
                currentRowWidth = 0
                currentRowTagCount = 0
                currentRowView = UIView()
                currentRowView.frame.origin.y = CGFloat(currentRow - 1) * (tagViewHeight + marginY)

                rowViews.append(currentRowView)
                addSubview(currentRowView)

                tag.frame.size.width = min(tag.frame.size.width, frame.width)
            }

            tag.frame.origin = CGPoint(x: currentRowWidth, y: 0)
            currentRowView.addSubview(tag)

            currentRowTagCount += 1
            currentRowWidth += tag.frame.width + marginX

            currentRowView.frame.origin.x = 0
            currentRowView.frame.size.width = currentRowWidth
            currentRowView.frame.size.height = max(tagViewHeight, currentRowView.frame.height)
        }
        rows = currentRow

        invalidateIntrinsicContentSize()
    }

    // MARK: - Manage tags

    private func createNewTag(_ title: String) -> Tag {
        let tagView = Tag(title: title)

        tagView.textColor = textColor
        tagView.selectedTextColor = selectedTextColor
        tagView.tagBackgroundColor = tagBackgroundColor

        tagView.selectedBackgroundColor = tagSelectedBackgroundColor
        tagView.titleLineBreakMode = tagLineBreakMode
        tagView.cornerRadius = cornerRadius
        tagView.paddingX = paddingX
        tagView.paddingY = paddingY
        tagView.textFont = textFont
        tagView.addTarget(self, action: #selector(tagPressed(_:)), for: .touchUpInside)

        return tagView
    }

    @discardableResult
    open func addTag(_ title: String) -> Tag {
        defer { refreshView() }
        return addTag(createNewTag(title))
    }

    @discardableResult
    open func addTags(_ titles: [String]) -> [Tag] {
        return addTag(titles.map(createNewTag))
    }

    open func select(_ titles: [String]) {
        for title in titles {
            for (index,tag) in tags.enumerated() {
                if title == tag.titleLabel?.text {
                    tags[index].isSelected = true
                }
            }
        }
    }

    @discardableResult
    open func addTag(_ tag: Tag) -> Tag {
        defer { refreshView() }
        tags.append(tag)

        return tag
    }


    @discardableResult
    open func addTag(_ tag: [Tag]) -> [Tag] {
        tag.forEach {
            addTag($0)
        }
        return tag
    }

    open func selectedTags() -> [Tag] {
        return tags.filter { $0.isSelected }
    }

    open func removeAllTags() {
        defer {
            tags = []
            refreshView()
        }

        let views: [UIView] = tags
        views.forEach { $0.removeFromSuperview() }
    }

    // MARK: - Events

    @objc func tagPressed(_ sender: Tag!) {
        sender.onTap?(sender)
        delegate?.tagPressed(sender.currentTitle, tag: sender, sender: self)
    }
}
