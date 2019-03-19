//
//  AuthPath.swift
//  TravelerKit
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
    case passes(Product, availability: Availability, option: BookingOption?)
    case questions(Product, passes: [Pass])
    case createOrder([BookingForm]) // Use an interface called Purchase in the future to capture buyables
    case processOrder(Order, Payment)

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
            urlComponents.queryItems = [URLQueryItem]()

            query.flights?.forEach { (flight) in
                urlComponents.queryItems!.append(URLQueryItem(name:"flight-ids", value: flight.id))
            }
        case .catalogItem(let item):
            urlComponents.path = "/product/\(item.id)"
        case .productSchedule(let product, let fromDate, let toDate):
            urlComponents.path = "/product/\(product.id)/schedule"
            urlComponents.queryItems = [
                URLQueryItem(name: "from", value: DateFormatter.yearMonthDay.string(from: fromDate)),
                URLQueryItem(name: "to", value: DateFormatter.yearMonthDay.string(from: toDate))
            ]
        case .passes(let product, let availability, let option):
            urlComponents.path = "product/\(product.id)/pass"
            urlComponents.queryItems = [
                URLQueryItem(name: "availability-id", value: availability.id)
            ]

            option.flatMap {
                urlComponents.queryItems?.append(
                    URLQueryItem(name: "option-id", value: $0.id)
                )
            }
        case .questions(let product, let passes):
            urlComponents.path = "/product/\(product.id)/question"
            urlComponents.queryItems = [URLQueryItem]()

            passes.forEach { (pass) in
                urlComponents.queryItems!.append(URLQueryItem(name: "pass-ids", value: pass.id))
            }
        case .createOrder(let forms):
            urlComponents.path = "/order"
            urlRequest.method = .post
            urlRequest.jsonBody = [
                "travelerProfileId": nil,
                "products": forms.map({
                    [
                        [
                            "id": $0.product.id,
                            "passes": $0.passes.map({ $0.id }),
                            "answers": $0.answers.values.map({
                                [
                                    "id": $0.questionId,
                                    "value": $0.codedValue
                                ]
                            })
                        ]
                    ]
                })
            ]
        case .processOrder(let order, let payment):
            urlComponents.path = "/order/\(order.id)"
            urlRequest.method = .patch
            urlRequest.httpBody = payment.securePayload()
        }

        urlRequest.url = urlComponents.url

        return urlRequest
    }
}
