//
//  GuestRoute.swift
//  Traveler
//
//  Created by Ata Namvari on 2019-03-26.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit
import GoogleSignIn

enum GuestRoute {
    case login(String)
}

extension GuestRoute: Route {
    var baseURL: URL {
        struct Endpoint {
            static var url: URL?
        }

        if let url = Endpoint.url {
            return url
        }

        let productionEndpoint = "https://9th3dtgfg3.execute-api.ca-central-1.amazonaws.com/dev/"

        guard let endpoint = UserDefaults.standard.string(forKey: "traveler_Authentication_Endpoint") else {
            return URL(string: productionEndpoint)!
        }

        Endpoint.url = URL(string: endpoint) ?? URL(string: productionEndpoint)!

        return Endpoint.url!
    }

    var urlRequest: URLRequest {
        switch self {
        case .login(let accessToken):
            var request = URLRequest(url: baseURL.appendingPathComponent("/login"))
            request.addValue(accessToken, forHTTPHeaderField: "x-access-token")
            return request
        }
    }

    func transform(error: Error) -> Error {
        return error
    }
}
