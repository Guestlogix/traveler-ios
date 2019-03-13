//
//  ValidationError.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-01-25.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public enum ValidationError: Error {
    case required(Any?)
    case invalidFormat(Any?)
}
