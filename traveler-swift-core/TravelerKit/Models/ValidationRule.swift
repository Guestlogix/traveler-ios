//
//  Validation.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-01-24.
//  Copyright © 2019 Guestlogix. All rights reserved.
//

import Foundation

/// The different validation rules a `Question` can have
public enum ValidationRule {
    /// It must be answered
    case required
    /// The answer must match the given RegEx pattern
    case pattern(NSRegularExpression)
}
