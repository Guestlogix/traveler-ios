//
//  Attribute.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-08.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

/// Represents an attribute
public struct Attribute: Decodable {
    /// Caption
    public let label: String
    /// Value
    public let value: String

    init(label: String, value: String) {
        self.label = label
        self.value = value
    }
}
