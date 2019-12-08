//
//  PurchaseFormFetchingError.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-12-02.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// Errors that occur when fetching a `PurchaseForm`
public enum PurchaseFormFetchingError: Error {
    /// When the options don't match the required type for a specific product.
    case optionTypeMismatch
    /// When options are required but not passed in the fetching parameters
    case noOptions
}
