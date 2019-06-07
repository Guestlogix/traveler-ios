//
//  CancellationError+LocalizedError.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-06-07.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit

extension CancellationError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .expiredQuote:
            return NSLocalizedString("Quote has expired", comment: "CancellationError")
        case .notCancellable:
            return NSLocalizedString("Quote not cancellable", comment: "CancellationError")
        }
    }
}
