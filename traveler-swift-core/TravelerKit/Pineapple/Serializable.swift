//
//  SerializingOperation.swift
//  Cardinal
//
//  Created by Ata Namvari on 2017-05-07.
//  Copyright © 2017 capco. All rights reserved.
//

import Foundation

public protocol Serializable {
    func serialize() -> [String: Any?]
}
