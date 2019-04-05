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

    /**
     Initializes a new Attribute

     - Parameters:
     - label: The label for the attribute
     - value: The value of the attribute
     */
    public init(label: String, value: String) {
        self.label = label
        self.value = value
    }
}
