//
//  NetworkError.swift
//  Lib
//
//  Created by Ata Namvari on 2017-10-20.
//  Copyright © 2017 capco. All rights reserved.
//

import Foundation

public enum NetworkError : Error {
    case notFound
    case unauthorized(Data?, HTTPURLResponse)
    case forbidden(Data?)
    case clientError(Int, Data?)
    case serverError(Int, Data?)
    case invalidResponse(Int)

    init?(data: Data?, response: HTTPURLResponse) {
        switch response.statusCode {
        case 200, 201:
            return nil
        case 204:
            return nil
        case 401:
            self = NetworkError.unauthorized(data, response)
        case 403:
            self = NetworkError.forbidden(data)
        case 404:
            self = NetworkError.notFound
        case 400...499:
            self = NetworkError.clientError(response.statusCode, data)
        case 500...599:
            self = NetworkError.serverError(response.statusCode, data)
        default:
            self = NetworkError.invalidResponse(response.statusCode)
        }
    }

    var data: Data? {
        switch self {
        case .clientError(_, let data),
             .serverError(_, let data),
             .unauthorized(let data, _):
            return data
        default:
            return nil
        }
    }

    var logLevel: LogLevel {
        switch self {
        case .unauthorized, .forbidden:
            return .warning
        default:
            return .error
        }
    }
}

extension NetworkError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .unauthorized,
             .forbidden,
             .notFound,
             .clientError,
             .serverError,
             .invalidResponse:
            return NSLocalizedString("networkServerError", value: "Unable to process your request right now, please try again later", comment: "Server Error")
        }
    }
}
