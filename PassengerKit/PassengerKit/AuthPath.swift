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
    case catalogItem(CatalogItem)
    case productSchedule(Product, from: Date, to: Date)
    case passes(Product, date: Date, time: Time?)

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
                urlComponents.queryItems = [
                    URLQueryItem(name: "flight-ids", value: flights.map({$0.id}).joined(separator: ","))
                ]
            }
        case .catalogItem(let item):
            urlComponents.path = "/product/\(item.id)"
        case .productSchedule(let product, let fromDate, let toDate):
            urlComponents.path = "/product/\(product.id)/schedule"
            urlComponents.queryItems = [
                URLQueryItem(name: "from", value: DateFormatter.yearMonthDay.string(from: fromDate)),
                URLQueryItem(name: "to", value: DateFormatter.yearMonthDay.string(from: toDate))
            ]
        case .passes(let product, let date, let time):
            urlComponents.path = "/product/\(product.id)/pass"
            urlComponents.queryItems = [
                URLQueryItem(name: "date", value: DateFormatter.dateOnlyFormatter.string(from: date))
            ]

            time.flatMap {
                urlComponents.queryItems?.append(
                    URLQueryItem(name: "timeInMinutes", value: String($0))
                )
            }
        }

        urlRequest.url = urlComponents.url

        return urlRequest
    }
}
