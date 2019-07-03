//
//  UnauthPath.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-09-25.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

enum UnauthPath {
    case authenticate(String)

    // MARK: URLRequest

    func urlRequest(baseURL: URL) -> URLRequest {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        var urlRequest = URLRequest(url: baseURL)

        switch self {
        case .authenticate(let apiKey):
            urlComponents.path = "/v1/auth/token"
            urlRequest.method = .get
            urlRequest.addValue(apiKey, forHTTPHeaderField: "x-api-key")
        }

        urlRequest.url = urlComponents.url

        return urlRequest
    }
}
