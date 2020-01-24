//
//  Route.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-09-05.
//  Copyright © 2018 Guestlogix Inc. All rights reserved.
//

import Foundation

enum PassengerRoute {
    case unauthenticated(UnauthPath)
    case authenticated(AuthPath, apiKey: String, token: Token)  //  TODO: Once there is a JWT validator on the gateway we wont need apiKey passed here
}

public let TRAVELER_SDK_ENDPOINT = "traveler_SDK_endpoint"

extension PassengerRoute: Route {
    var baseURL: URL {
        struct Endpoint {
            static var url: URL?
        }

        if let url = Endpoint.url {
            return url
        }

        let productionEndpoint = "https://traveler.guestlogix.io"

        // TODO: add the v1 to the above URL

        guard let endpoint = UserDefaults.standard.string(forKey: TRAVELER_SDK_ENDPOINT) else {
            return URL(string: productionEndpoint)!
        }

        Endpoint.url = URL(string: endpoint) ?? URL(string: productionEndpoint)!

        return Endpoint.url!
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

        urlRequest.addValue(Traveler.shared?.device.identifier ?? "[NO_DEVICE]", forHTTPHeaderField: "x-device-id")
        urlRequest.addValue(Traveler.shared?.device.osVersion ?? "[NO_OS_VERSION]", forHTTPHeaderField: "x-os-version")
        urlRequest.addValue(Locale.current.languageCode ?? "en", forHTTPHeaderField: "x-language")
        urlRequest.addValue(Locale.current.regionCode ?? "US", forHTTPHeaderField: "x-region")
        let localeIdentifier = Locale.current.identifier.components(separatedBy: "@").first
        urlRequest.addValue(localeIdentifier ?? "en_US", forHTTPHeaderField: "x-locale")
        urlRequest.addValue(Bundle.main.bundleIdentifier ?? "[NO_BUNDLE_IDENTIFIER]", forHTTPHeaderField: "x-application-id")
        urlRequest.addValue(TimeZone.current.identifier, forHTTPHeaderField: "x-timezone")
        urlRequest.addValue(Traveler.shared?.sandboxMode.description ?? "false", forHTTPHeaderField: "x-sandbox-mode")

        return urlRequest
    }

    func transform(error: Error) -> Error {
        guard case NetworkError.clientError(_, .some(let data)) = error else {
            return error
        }

        guard let errorJSON = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
            let errorCode = errorJSON["errorCode"] as? Int else {
            Log("Bad JSON", data: String(data: data, encoding: .utf8), level: .error)
            return error
        }

        switch errorCode {
        case 2006:
            return BookingError.noPasses
        case 2007:
            return BookingError.veryOldTraveler
        case 2012...2014:
            return CancellationError.notCancellable
        case 2015:
            return BookingError.adultAgeInvalid
        case 2017:
            return BookingError.belowMinUnits
        case 2018:
            return BookingError.unaccompaniedChildren
        default:
            Log("Unknown error code", data: errorJSON, level: .warning)
            return error
        }
    }
}
