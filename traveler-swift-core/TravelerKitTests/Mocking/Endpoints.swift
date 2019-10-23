//
//  Endpoints.swift
//  TravelerKitTests
//
//  Created by Omar Padierna on 2019-10-26.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

enum APISection {
    case authenticate(key: String)
    case flights(number: String, date: Date)
    case catalog(flights: [String]?)
    
    var urls: [URL] {
        let baseURLs = [URL(string: "https://traveler.dev.guestlogix.io")!, URL(string: "https://traveler.rc.guestlogix.io")!, URL(string: "https://traveler.guestlogix.io")!]
        
        return baseURLs.map { (baseURL) -> URL in
            var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
            switch self {
            case .authenticate( _):
                urlComponents.path = "/v1/auth/token"
            case .flights(let number, let date):
                urlComponents.path = "/v1/flight"
                urlComponents.queryItems = [
                    URLQueryItem(name: "flight-number", value: number),
                    URLQueryItem(name: "departure-date", value: DateFormatter.yearMonthDay.string(from: date))
                ]
            case .catalog(let flights):
                urlComponents.path = "/v1/catalog-group"
                urlComponents.queryItems = [URLQueryItem]()

                flights?.forEach { (flight) in
                    urlComponents.queryItems!.append(URLQueryItem(name: "flight-ids", value: flight))
                }
            }

            guard let resultURL = urlComponents.url else {
                fatalError("Bad URL")
            }

            return resultURL
        }
    }
}
