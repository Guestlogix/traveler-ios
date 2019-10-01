//
//  CatalogItemDetails+TravelerUI.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-02-08.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit

extension BookingItemDetails {
    public var attributedDescription: NSMutableAttributedString? {
        guard let description = description else {
            return nil
        }

        let attr = try? NSMutableAttributedString(data: description.data(using: .utf8)!,
                                                  options: [.documentType : NSAttributedString.DocumentType.html],
                                                  documentAttributes: nil)

        return attr
    }

    public var attributedTermsAndConditions: NSMutableAttributedString? {
        guard let termsAndConditions = termsAndConditions else {
            return nil
        }

        let attr = try? NSMutableAttributedString(data: termsAndConditions.data(using: .utf8)!, options: [.documentType: NSMutableAttributedString.DocumentType.html], documentAttributes: nil)

        return attr
    }
}
