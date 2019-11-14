//
//  BookingOption+TravelerUI.swift
//  TravelerKitUI
//
//  Created by Ben Ruan on 2019-10-01.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit

extension BookingOption {
    public var attributedDisclaimer: NSMutableAttributedString? {
        guard let disclaimer = disclaimer else {
            return nil
        }

        let attr = try? NSMutableAttributedString(data: disclaimer.data(using: .utf8)!,
                                                  options: [.documentType : NSAttributedString.DocumentType.html],
                                                  documentAttributes: nil)

        if #available(iOS 13.0, *) {
            // This is to maintain the label color when using attributed strings in dark mode
            attr?.addAttribute(.foregroundColor, value: UIColor.secondaryLabel, range: NSRange(location: 0, length: attr!.string.count))
        }

        return attr
    }
}
