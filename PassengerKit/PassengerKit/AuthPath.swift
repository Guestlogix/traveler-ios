//
//  AuthPath.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-09-25.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

enum AuthPath {
    case flights(FlightQuery)
    case user
    case updateUser(User)

    // MARK: URLRequest

    func urlRequest(baseURL: URL) -> URLRequest {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        var urlRequest = URLRequest(url: baseURL)

        switch self {
        case .flights(let query):
            urlComponents.path = "/trip"
            urlComponents.queryItems = [
                URLQueryItem(name: "carrier-code", value: query.carrierCode),
                URLQueryItem(name: "trip-number", value: query.number),
                URLQueryItem(name: "departure-date", value: DateFormatter.yearMonthDay.string(from: query.date))
            ]
        case .user:
            urlComponents.path = "/user"
        case .updateUser(let user):
            urlComponents.path = "/user/\(user)"
            urlRequest.method = .post
            urlRequest.httpBody = try? JSONEncoder().encode(user)
        }

        urlRequest.url = urlComponents.url

        return urlRequest
    }
}
