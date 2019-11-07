//
//  CatalogItemDetails+TravelerUI.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-02-08.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit

extension CatalogItemDetails {
    public var attributedDescription: NSMutableAttributedString? {
        guard let description = description else {
            return nil
        }

        let attr = try? NSMutableAttributedString(data: description.data(using: .utf8)!,
                                                  options: [.documentType : NSAttributedString.DocumentType.html],
                                                  documentAttributes: nil)
        
        if #available(iOS 13.0, *) {
            // This is to maintain the label color when using attributed strings in dark mode
            attr?.addAttribute(.foregroundColor, value: UIColor.label, range: NSRange(location: 0, length: attr!.string.count))
        }

        return attr
    }

    public var attributedTermsAndConditions: NSMutableAttributedString? {
        guard let termsAndConditions = termsAndConditions else {
            return nil
        }

        let attr = try? NSMutableAttributedString(data: termsAndConditions.data(using: .utf8)!, options: [.documentType: NSMutableAttributedString.DocumentType.html], documentAttributes: nil)
        
        if #available(iOS 13.0, *) {
            // This is to maintain the label color when using attributed strings in dark mode
            attr?.addAttribute(.foregroundColor, value: UIColor.label, range: NSRange(location: 0, length: attr!.string.count))
        }

        return attr
    }
}
