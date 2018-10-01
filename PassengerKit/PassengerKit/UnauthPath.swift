//
//  UnauthPath.swift
//  PassengerKit
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
            urlComponents.path = "/auth/token"
            urlRequest.method = .post
            urlRequest.addValue(apiKey, forHTTPHeaderField: "x-api-key")
            urlRequest.jsonBody = [
                "deviceId": UIDevice.current.identifierForVendor?.uuidString ?? "[NO_DEVICE_ID]",
                "osVersion": UIDevice.current.systemName + UIDevice.current.systemVersion,
                "lanugage": Locale.current.languageCode ?? "en",
                "locale": Locale.current.variantCode ?? "en_POSIX",
                "region": Locale.current.regionCode ?? "US",
                "applicationId": Bundle.main.bundleIdentifier ?? "[NO_BUNDLE_IDENTIFIER]"
            ]
        }

        urlRequest.url = urlComponents.url

        return urlRequest
    }
}
