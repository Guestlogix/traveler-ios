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
        return URL(string: "https://67edtu2ifi.execute-api.ca-central-1.amazonaws.com/dev")!
    }

    var urlRequest: URLRequest {
        switch self {
        case .login(let accessToken):
            var request = URLRequest(url: baseURL.appendingPathComponent("/login"))
            request.addValue(accessToken, forHTTPHeaderField: "x-access-token")
            return request
        }
    }
}
