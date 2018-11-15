//
//  Route.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-09-05.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import Foundation

enum PassengerRoute {
    case unauthenticated(UnauthPath)
    case authenticated(AuthPath, apiKey: String, token: Token)  //  TODO: Once there is a JWT validator on the gateway we wont need apiKey passed here
    
}

extension PassengerRoute: Route {
    var baseURL: URL {
        return URL(string: "https://guest-api-dev-1.guestlogix.io")!
    }

    var urlRequest: URLRequest {
        var urlRequest: URLRequest

        switch self {
        case .unauthenticated(let path):
            urlRequest = path.urlRequest(baseURL: baseURL)
        case .authenticated(let path, let apiKey, let token):
            urlRequest = path.urlRequest(baseURL: baseURL)
            urlRequest.addValue(apiKey, forHTTPHeaderField: "x-api-key")
            urlRequest.addValue("Bearer \(token.value)", forHTTPHeaderField: "Authorization")
        }

        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("application/json", forHTTPHeaderField: "Accept")

        return urlRequest
    }

    func error(from error: Error) -> Error {
        return error
    }
}
