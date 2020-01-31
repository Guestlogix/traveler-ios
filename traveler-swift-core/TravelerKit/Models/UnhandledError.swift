//
//  UnhandledError.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2020-01-29.
//  Copyright © 2020 Guestlogix. All rights reserved.
//

import Foundation

public enum UnhandledError: Error {
    case error(errorMessage: String, errorCode: Int, traceId: String)
}

extension UnhandledError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .error(let errorMessage, let errorCode, let traceId):
            let description = NSLocalizedString("unhandledError", value: "\(errorMessage) \n error code : \(errorCode)", comment: "Unhandled backend errors")
            return localizedDescription(description: description, withTraceId: traceId)
        }
    }
}
