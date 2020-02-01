//
//  ValidationError.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-01-25.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// The different types of errors that can occur when validating `Answer`s to a `Question`
public enum ValidationError: Error {
    /// No `Answer` was provided
    case required(Any?)
    /// The `Answer` does not match the expected format
    case invalidFormat(Any?, String)
}
