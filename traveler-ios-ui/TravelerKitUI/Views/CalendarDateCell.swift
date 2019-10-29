//
//  CalendarDateCell.swift
//  TravelerKitUI
//
//  Created by Ben Ruan on 2019-10-29.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import UIKit
import TravelerKit

class CalendarDateCell: UICollectionViewCell {
    @IBOutlet weak var dateLabel: UILabel!

    var date: Date? {
        didSet {
            if let newDateValue = date {
                if Calendar.current.compare(newDateValue, to: Date(), toGranularity: .day) == .orderedSame {
                    let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue]
                    let underlineAttributedString = NSAttributedString(string: String(Calendar.current.component(.day, from: newDateValue)), attributes: underlineAttribute)
                    dateLabel.attributedText = underlineAttributedString
                } else {
                    dateLabel.text = String(Calendar.current.component(.day, from: newDateValue))
                }
            }
        }
    }
    var isAvailable: Bool = false {
        didSet {
            dateLabel.textColor = isAvailable == true ? .black : .lightGray
            isUserInteractionEnabled = isAvailable
        }
    }

    override var isSelected: Bool  {
        didSet {
            // TODO: replace hard-coded color with theme color
            backgroundColor = isSelected == true ? .blue : .clear
            dateLabel.textColor = isSelected == true ? .white : (isAvailable ? .black : .lightGray)
        }
    }
}
