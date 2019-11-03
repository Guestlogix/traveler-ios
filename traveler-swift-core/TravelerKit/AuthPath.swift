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
    case bookingItem(Product, travelerId: String?)
    case parkingItem(Product, travelerId: String?)
    case productSchedule(Product, from: Date, to: Date)
    case passes(Product, availability: Availability, option: BookingOption?)
    case bookingQuestions(Product, passes: [Pass])
    case parkingQuestions(Product)
    case createOrder([PurchaseForm], travelerId: String?) // Use an interface called Purchase in the future to capture buyables
    case processOrder(Order, Payment)
    case orders(OrderQuery, travelerId: String)
    case cancellationQuote(Order)
    case cancelOrder(CancellationRequest)
    case emailOrderConfirmation(Order)
    case wishlistAdd(Product, travelerId: String)
    case wishlistRemove(Product, travelerId: String)
    case wishlist(WishlistQuery, travelerId: String)
    case searchBookingItems(BookingItemQuery)
    case searchParkingItems(ParkingItemQuery)
    case similarItems(Product)

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
            urlComponents.path = "/v1/catalog-group"
            urlComponents.queryItems = [URLQueryItem]()

            query.flights?.forEach { (flight) in
                urlComponents.queryItems!.append(URLQueryItem(name:"flight-ids", value: flight.id))
            }
        case .bookingItem(let item, let travelerId):
            urlComponents.path = "/v1/booking/\(item.id)"
            if let _ = travelerId {
                urlComponents.queryItems = [
                    URLQueryItem(name: "travelerId", value: travelerId)
                ]
            }
        case .parkingItem(let item, let travelerId):
            urlComponents.path = "/v1/parking/\(item.id)"
            if let _ = travelerId {
                urlComponents.queryItems = [
                    URLQueryItem(name: "travelerId", value: travelerId)
                ]
            }
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
        case .bookingQuestions(let product, let passes):
            urlComponents.path = "/v1/booking/\(product.id)/question"
            urlComponents.queryItems = [URLQueryItem]()

            passes.forEach { (pass) in
                urlComponents.queryItems!.append(URLQueryItem(name: "pass-ids", value: pass.id))
            }
        case .parkingQuestions(let product):
            urlComponents.path = "/v1/parking/\(product.id)/question"
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
        case .cancelOrder(let request):
            urlComponents.path = "/v1/order/\(request.quote.order.id)/cancellation/\(request.quote.id)"
            urlRequest.jsonBody = [
                "cancellationReason": request.reason.id,
                "cancellationReasonText": request.explanation ?? ""
            ]

            urlRequest.method = .patch
        case .emailOrderConfirmation(let order):
            urlComponents.path = "/v1/order/\(order.id)/ticket"
            urlRequest.method = .patch
        case .wishlistAdd(let product, let travelerId):
            urlComponents.path = "/v1/traveler/\(travelerId)/wishlist"
            urlRequest.method = .post
            urlRequest.jsonBody = [
                "product_id": product.id
            ]
        case .wishlistRemove(let product, let travelerId):
            urlComponents.path = "/v1/traveler/\(travelerId)/wishlist/\(product.id)"
            urlRequest.method = .delete
        case .wishlist(let query, let travelerId):
            urlComponents.path = "/v1/traveler/\(travelerId)/wishlist"
            urlRequest.method = .get
            urlComponents.queryItems = [
                URLQueryItem(name: "skip", value: String(query.offset)),
                URLQueryItem(name: "take", value: String(query.limit)),
                URLQueryItem(name: "to", value: ISO8601DateFormatter.fullFormatter.string(from: query.toDate))
            ]

            if let fromDate = query.fromDate {
                urlComponents.queryItems?.append(
                    URLQueryItem(name: "from", value: ISO8601DateFormatter.fullFormatter.string(from: fromDate))
                )
            }
        case .searchBookingItems(let searchQuery):
            urlComponents.path = "/v1/booking"
            urlRequest.method = .get
            urlComponents.queryItems = [
                URLQueryItem(name: "text", value: searchQuery.text),
                URLQueryItem(name: "skip", value: String(searchQuery.offset)),
                URLQueryItem(name: "take", value: String(searchQuery.limit))]

            searchQuery.categories.forEach({ (category) in
                urlComponents.queryItems?.append(URLQueryItem(name: "categories", value: category.rawValue))
            })

            if let priceRange = searchQuery.priceRange {
                urlComponents.queryItems?.append(URLQueryItem(name: "min-price", value: String(priceRange.range.lowerBound)))
                urlComponents.queryItems?.append(URLQueryItem(name: "max-price", value: String(priceRange.range.upperBound)))
                urlComponents.queryItems?.append(URLQueryItem(name: "currency", value: priceRange.currency.rawValue))
            }
            if let boundingBox = searchQuery.boundingBox {
                let topLeftCoordinate = boundingBox.topLeftCoordinate
                let bottomRightCoordinate = boundingBox.bottomRightCoordinate

                urlComponents.queryItems?.append(URLQueryItem(name: "top-left-latitude", value: String(topLeftCoordinate.latitude)))
                urlComponents.queryItems?.append(URLQueryItem(name: "top-left-longitude", value: String(topLeftCoordinate.longitude)))
                urlComponents.queryItems?.append(URLQueryItem(name: "bottom-right-latitude", value: String(bottomRightCoordinate.latitude)))
                urlComponents.queryItems?.append(URLQueryItem(name: "bottom-right-longitude", value: String(bottomRightCoordinate.longitude)))
            }
        case .searchParkingItems(let searchQuery):
            urlComponents.path = "/v1/parking"
            urlRequest.method = .get
            urlComponents.queryItems = [
                URLQueryItem(name: "to", value: DateFormatter.withoutTimezone.string(from: searchQuery.dateRange.upperBound)),
                URLQueryItem(name: "from", value: DateFormatter.withoutTimezone.string(from: searchQuery.dateRange.lowerBound)),
            URLQueryItem(name: "skip", value: String(searchQuery.offset)),
            URLQueryItem(name: "take", value: String(searchQuery.limit))]

            if let boundingBox = searchQuery.boundingBox {
                let topLeftCoordinate = boundingBox.topLeftCoordinate
                let bottomRightCoordinate = boundingBox.bottomRightCoordinate

                urlComponents.queryItems?.append(URLQueryItem(name: "top-left-latitude", value: String(topLeftCoordinate.latitude)))
                urlComponents.queryItems?.append(URLQueryItem(name: "top-left-longitude", value: String(topLeftCoordinate.longitude)))
                urlComponents.queryItems?.append(URLQueryItem(name: "bottom-right-latitude", value: String(bottomRightCoordinate.latitude)))
                urlComponents.queryItems?.append(URLQueryItem(name: "bottom-right-longitude", value: String(bottomRightCoordinate.longitude)))
            }

            urlComponents.queryItems?.append(URLQueryItem(name: "airport", value: searchQuery.airportIATA))
        case .similarItems(let item):
            urlComponents.path = "/v1/catalog-group/\(item.id)"
            urlRequest.method = .get
        }
        
        urlRequest.url = urlComponents.url

        return urlRequest
    }
}
