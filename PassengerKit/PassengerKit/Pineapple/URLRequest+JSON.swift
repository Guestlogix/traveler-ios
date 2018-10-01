//
//  URLRequest+JSON.swift
//  Cardinal
//
//  Created by Ata Namvari on 2017-05-08.
//  Copyright © 2017 capco. All rights reserved.
//

import Foundation

public extension URLRequest {
    public enum HTTPMethod : String {
        case get = "GET"
        case post = "POST"
        case patch = "PATCH"
        case delete = "DELETE"
        case put = "PUT"
    }

    public var jsonBody: Any? {
        get {
            return httpBody.flatMap { try? JSONSerialization.jsonObject(with: $0, options: .allowFragments) }
        }
        set {
            httpBody = newValue.flatMap { try? JSONSerialization.data(withJSONObject: $0, options: .prettyPrinted) }
        }
    }

    public var method: HTTPMethod? {
        get {
            let httpMethod = self.httpMethod ?? "GET"
            return HTTPMethod(rawValue: httpMethod)
        }
        set {
            httpMethod = newValue?.rawValue
        }
    }
}
