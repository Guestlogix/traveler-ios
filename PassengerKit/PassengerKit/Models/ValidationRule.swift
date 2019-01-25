//
//  Validation.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2019-01-24.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public enum ValidationRule {
    case required
    case pattern(NSRegularExpression)
}
