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
    case createOrder(BookingForm, BookingContext)
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

            if let flights = query.flights, flights.count > 0 {
                var urlQueryItemArray: [URLQueryItem] = []
                for flight in flights {
                    urlQueryItemArray.append(URLQueryItem(name:"flight-ids", value: flight.id))
                }
                
                urlComponents.queryItems = urlQueryItemArray
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
                    URLQueryItem(name: "time-in-minutes", value: String($0))
                )
            }
        case .createOrder(let form, let context):
            urlComponents.path = "/order"
            urlRequest.method = .post
            urlRequest.jsonBody = [
                "travelerProfileId": nil,
                // TODO: Currency handling
                "amount": [
                    "value": form.passes.map({ $0.price.value }).reduce(0, +),
                    "currency": Locale.current.currencyCode as Any
                ],
                "products": [
                    [
                        "id": context.product.id,
                        "passes": form.passes.enumerated().map({ (index, pass) in
                            [
                                "id": pass.id,
                                "title": pass.name,
                                "answers": form.answers(passAt: index).map({ (answer) in
                                    [
                                        "id": answer.questionId,
                                        "value": answer.codedValue
                                    ]
                                }),
                                "upsellAnswers": []
                            ]
                        })
                    ]
                ],
                "customer": form.questionGroups[0].questions.reduce([:], { (contact, q) -> [String: Any?] in
                    var contact = contact
                    contact[q.id] = try? form.answer(for: q)?.codedValue
                    return contact
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
