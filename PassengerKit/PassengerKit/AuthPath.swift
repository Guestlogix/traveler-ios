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
    case catalog(CatalogQuery)
    case user
    case updateUser(User)

    // MARK: URLRequest

    func urlRequest(baseURL: URL) -> URLRequest {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        var urlRequest = URLRequest(url: baseURL)

        switch self {
        case .flights(let query):
            urlComponents.path = "/flight"
            urlComponents.queryItems = [
                URLQueryItem(name: "flight-number", value: query.number),
                URLQueryItem(name: "departure-date", value: DateFormatter.yearMonthDay.string(from: query.date))
            ]
        case .catalog(let query):
            urlComponents.path = "/catalog"

            if let flights = query.flights, flights.count > 0 {
                urlComponents.queryItems = [URLQueryItem(name: "flight-ids", value: flights.map({$0.id}).joined(separator: ","))]
            }
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
