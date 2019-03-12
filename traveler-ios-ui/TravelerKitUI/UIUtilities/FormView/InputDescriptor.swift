//
//  InputDescriptor.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-12-17.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public struct InputDescriptor {
    public let type: InputType
    public let label: String?

    public init(type: InputType, label: String? = nil) {
        self.type = type
        self.label = label
    }
}
