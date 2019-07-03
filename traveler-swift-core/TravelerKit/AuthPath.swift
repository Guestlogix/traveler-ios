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
    case catalogItem(Product)
    case productSchedule(Product, from: Date, to: Date)
    case passes(Product, availability: Availability, option: BookingOption?)
    case questions(Product, passes: [Pass])
    case createOrder([BookingForm], travelerId: String?) // Use an interface called Purchase in the future to capture buyables
    case processOrder(Order, Payment)
    case orders(OrderQuery, travelerId: String)
    case cancellationQuote(Order)
    case cancelOrder(CancellationQuote)
    case emailOrderConfirmation(Order)

    // MARK: URLRequest

    func urlRequest(baseURL: URL) -> URLRequest {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        var urlRequest = URLRequest(url: baseURL)

        switch self {
        case .flights(let query):
            urlComponents.path = "/v1/flight"
            urlComponents.queryItems = [
                URLQueryItem(name: "flight-number", value: query.number),
                URLQueryItem(name: "departure-date", value: DateFormatter.yearMonthDay.string(from: query.date))
            ]
        case .catalog(let query):
            urlComponents.path = "/v1/catalog"
            urlComponents.queryItems = [URLQueryItem]()

            query.flights?.forEach { (flight) in
                urlComponents.queryItems!.append(URLQueryItem(name:"flight-ids", value: flight.id))
            }
        case .catalogItem(let item):
            urlComponents.path = "/v1/product/\(item.id)"
        case .productSchedule(let product, let fromDate, let toDate):
            urlComponents.path = "/v1/product/\(product.id)/schedule"
            urlComponents.queryItems = [
                URLQueryItem(name: "from", value: DateFormatter.yearMonthDay.string(from: fromDate)),
                URLQueryItem(name: "to", value: DateFormatter.yearMonthDay.string(from: toDate))
            ]
        case .passes(let product, let availability, let option):
            urlComponents.path = "/v1/product/\(product.id)/pass"
            urlComponents.queryItems = [
                URLQueryItem(name: "availability-id", value: availability.id)
            ]

            option.flatMap {
                urlComponents.queryItems?.append(
                    URLQueryItem(name: "option-id", value: $0.id)
                )
            }
        case .questions(let product, let passes):
            urlComponents.path = "/v1/product/\(product.id)/question"
            urlComponents.queryItems = [URLQueryItem]()

            passes.forEach { (pass) in
                urlComponents.queryItems!.append(URLQueryItem(name: "pass-ids", value: pass.id))
            }
        case .createOrder(let forms, let travelerId):
            urlComponents.path = "/v1/order"
            urlRequest.method = .post
            urlRequest.jsonBody = [
                "travelerId": travelerId as Any,
                "amount": [ // TODO: Set actual amounts when we get price from the backend
                    "value": 0,
                    "currency": "USD"
                ],
                "products": forms.map({
                    [
                        "id": $0.product.id,
                        "passes": $0.passes.map({ $0.id }),
                        "answers": $0.answers.values.map({
                            [
                                "questionId": $0.questionId,
                                "value": $0.codedValue
                            ]
                        })
                    ]
                })
            ]
        case .processOrder(let order, let payment):
            urlComponents.path = "/v1/order/\(order.id)"
            urlRequest.method = .patch
            urlRequest.httpBody = payment.securePayload()
        case .orders(let query, let travelerId):
            urlComponents.path = "/v1/order"
            urlComponents.queryItems = [
                URLQueryItem(name: "traveler", value: travelerId),
                URLQueryItem(name: "skip", value: String(query.offset)),
                URLQueryItem(name: "take", value: String(query.limit)),
                URLQueryItem(name: "to", value: ISO8601DateFormatter.fullFormatter.string(from: query.toDate))
            ]

            if let fromDate = query.fromDate {
                urlComponents.queryItems?.append(
                    URLQueryItem(name: "from", value: ISO8601DateFormatter.fullFormatter.string(from: fromDate))
                )
            }
        case .cancellationQuote(let order):
            urlComponents.path = "/v1/order/\(order.id)/cancellation"
        case .cancelOrder(let quote):
            urlComponents.path = "/v1/order/\(quote.order.id)/cancellation/\(quote.id)"
            urlRequest.method = .patch
        case .emailOrderConfirmation(let order):
            urlComponents.path = "/order/\(order.id)/ticket"
            urlRequest.method = .patch
        }

        urlRequest.url = urlComponents.url

        return urlRequest
    }
}
