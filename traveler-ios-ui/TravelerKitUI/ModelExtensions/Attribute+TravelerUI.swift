//
//  Attribute+TravelerUI.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-02-08.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit

extension Attribute {
    public var attributedValue: NSMutableAttributedString? {
        let attr = try? NSMutableAttributedString(data: value.data(using: .utf8)!,
                                                  options: [.documentType : NSAttributedString.DocumentType.html],
                                                  documentAttributes: nil)

        return attr
    }
}
