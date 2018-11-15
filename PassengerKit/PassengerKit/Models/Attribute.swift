//
//  Attribute.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-11-08.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public struct Attribute: Decodable {
    public let label: String
    public let value: String
    public lazy var attributedValue: NSMutableAttributedString? = {
        let attr = try? NSMutableAttributedString(data: value.data(using: .utf8)!,
                                                  options: [.documentType : NSAttributedString.DocumentType.html],
                                                  documentAttributes: nil)

        return attr
    }()

    init(label: String, value: String) {
        self.label = label
        self.value = value
    }
}
