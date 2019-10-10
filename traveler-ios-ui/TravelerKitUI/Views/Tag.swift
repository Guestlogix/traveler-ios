//
//  Tag.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-09-09.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

/*
 Modified from https://github.com/ElaWorkshop/TagListView
 */

import UIKit

@IBDesignable
open class Tag: UIButton {

    @IBInspectable open var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }

    @IBInspectable open var textColor: UIColor = UIColor.white {
        didSet {
            reloadStyles()
        }
    }
    @IBInspectable open var selectedTextColor: UIColor = UIColor.white {
        didSet {
            reloadStyles()
        }
    }
    @IBInspectable open var titleLineBreakMode: NSLineBreakMode = .byTruncatingMiddle {
        didSet {
            titleLabel?.lineBreakMode = titleLineBreakMode
        }
    }
    @IBInspectable open var paddingY: CGFloat = 2 {
        didSet {
            titleEdgeInsets.top = paddingY
            titleEdgeInsets.bottom = paddingY
        }
    }
    @IBInspectable open var paddingX: CGFloat = 5 {
        didSet {
            titleEdgeInsets.left = paddingX
            updateRightInsets()
        }
    }

    @IBInspectable open var tagBackgroundColor: UIColor = UIColor.gray {
        didSet {
            reloadStyles()
        }
    }

    @IBInspectable open var selectedBackgroundColor: UIColor? {
        didSet {
            reloadStyles()
        }
    }

    @IBInspectable open var textFont: UIFont = .systemFont(ofSize: 17) {
        didSet {
            titleLabel?.font = textFont
        }
    }

    private func reloadStyles() {
        if isSelected {
            backgroundColor = selectedBackgroundColor ?? tagBackgroundColor
            setTitleColor(selectedTextColor, for: UIControl.State())
        }
        else {
            backgroundColor = tagBackgroundColor
            setTitleColor(textColor, for: UIControl.State())
        }
    }


    override open var isSelected: Bool {
        didSet {
            reloadStyles()
        }
    }


    /// Handles Tap (TouchUpInside)
    open var onTap: ((Tag) -> Void)?

    // MARK: - init

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setupView()
    }

    public init(title: String) {
        super.init(frame: CGRect.zero)
        setTitle(title, for: UIControl.State())

        setupView()
    }

    private func setupView() {
        titleLabel?.lineBreakMode = titleLineBreakMode

        frame.size = intrinsicContentSize
    }

    // MARK: - layout

    override open var intrinsicContentSize: CGSize {
        var size = titleLabel?.text?.size(withAttributes: [NSAttributedString.Key.font: textFont]) ?? CGSize.zero
        size.height = textFont.pointSize + paddingY * 2
        size.width += paddingX * 2
        if size.width < size.height {
            size.width = size.height
        }
        return size
    }

    private func updateRightInsets() {
            titleEdgeInsets.right = paddingX
    }
}
