//
//  AuthPath.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-09-25.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

enum AuthPath {
    case storeAttributes([String: Any?], travelerId: String)
    case stripeEphemeralKey(version: String, travlerId: String)
    case flights(FlightQuery)
    case catalog(CatalogQuery)
    case bookingItem(Product, travelerId: String?)
    case parkingItem(Product, travelerId: String?)
    case partnerOfferingItem(Product, travelerID: String?)
    case productSchedule(Product, from: Date, to: Date)
    case passes(Product, availability: Availability, option: BookingOption?)
    case partnerOfferings(PartnerOfferingItem)
    case bookingQuestions(Product, passes: [Pass], travelerId: String?)
    case partnerOfferingsQuestions(Product, offerings: [PartnerOffering], travelerId: String?)
    case parkingQuestions(Product, travelerId: String?)
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
    case itinerary(ItineraryQuery, travelerId: String)
    case bookingPurchasedProductDetails(PurchasedProductDetailsQuery)
    case parkingPurchasedProductDetails(PurchasedProductDetailsQuery)
    case partnerPurchasedProductDetails(PurchasedProductDetailsQuery)
    case categories(itemType: PurchaseType)

    // MARK: URLRequest

    func urlRequest(baseURL: URL) -> URLRequest {
        var urlComponents = URLComponents(url: baseURL, resolvingAgainstBaseURL: true)!
        var urlRequest = URLRequest(url: baseURL)

        switch self {

        case .storeAttributes(let attributes, let travelerId):
            urlComponents.path = "/v1/traveler/\(travelerId)"
            urlRequest.method = .put
            urlRequest.jsonBody = attributes
        case .stripeEphemeralKey(let version, let travlerId):
            urlComponents.path = "/v1/traveler/\(travlerId)/stripeEphemeralKey"
            urlComponents.queryItems = [
                URLQueryItem(name: "api-version", value: version)
            ]
        case .flights(let query):
            urlComponents.path = "/v1/flight"
            urlComponents.queryItems = [
                URLQueryItem(name: "flight-number", value: query.number),
                URLQueryItem(name: "departure-date", value: DateFormatter.yearMonthDay.string(from: query.date))
            ]
        case .catalog(let query):
            urlComponents.path = "/v1/catalog-group"
            urlComponents.queryItems = [
                URLQueryItem(name: "city", value: query.city)
            ]

            if let location = query.location {
                urlComponents.queryItems?.append(URLQueryItem(name: "latitude", value: String(location.latitude)))
                urlComponents.queryItems?.append(URLQueryItem(name: "longitude", value: String(location.longitude)))
            }

            query.flights?.forEach { (flight) in
                urlComponents.queryItems!.append(URLQueryItem(name:"flight-ids", value: flight.id))
            }

            query.products?.forEach({ (product) in
                urlComponents.queryItems!.append(URLQueryItem(name:"product-ids", value: product.id))
            })
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
        case .partnerOfferingItem(let item, let travelerId):
            urlComponents.path = "/v1/menu/\(item.id)"
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
        case .partnerOfferings(let item):
            urlComponents.path = "/v1/menu/\(item.id)/offerings"
        case .bookingQuestions(let product, let passes, let travelerId):
            urlComponents.path = "/v1/booking/\(product.id)/question"
            urlComponents.queryItems = [URLQueryItem]()

            passes.forEach { (pass) in
                urlComponents.queryItems!.append(URLQueryItem(name: "pass-ids", value: pass.id))
            }

            if let _ = travelerId {
                urlComponents.queryItems!.append(URLQueryItem(name: "travelerId", value: travelerId))
            }
        case .partnerOfferingsQuestions(let product, let options, let travelerId):
            urlComponents.path = "/v1/menu/\(product.id)/questions"
            urlComponents.queryItems = [URLQueryItem]()

            options.forEach { (option) in
                urlComponents.queryItems!.append(URLQueryItem(name: "pass-ids", value: option.id))
            }

            if let _ = travelerId {
                urlComponents.queryItems!.append(URLQueryItem(name: "travelerId", value: travelerId))
            }
        case .parkingQuestions(let product, let travelerId):
            urlComponents.path = "/v1/parking/\(product.id)/question"
            if let _ = travelerId {
                urlComponents.queryItems = [
                    URLQueryItem(name: "travelerId", value: travelerId)
                ]
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
                        "passes": $0.offerings.map({ $0.id }),
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
            urlComponents.path = "/v1/traveler/\(travelerId)/order"
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
                URLQueryItem(name: "take", value: String(searchQuery.limit)),
                URLQueryItem(name: "country", value: searchQuery.country),
                URLQueryItem(name: "city", value: searchQuery.city)]

            searchQuery.categories.forEach({ (category) in
                urlComponents.queryItems?.append(URLQueryItem(name: "categories", value: category.id))
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

            if let location = searchQuery.location {
                urlComponents.queryItems?.append(URLQueryItem(name: "latitude", value: String(location.latitude)))
                urlComponents.queryItems?.append(URLQueryItem(name: "longitude", value: String(location.longitude)))
            }
            
            if let sortOption = searchQuery.sortOption {
                urlComponents.queryItems?.append(URLQueryItem(name: "sort-field", value: sortOption.rawValue))
            }
            
            if let sortOrder = searchQuery.sortOrder {
                urlComponents.queryItems?.append(URLQueryItem(name: "sort-order", value: sortOrder.rawValue))
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
        case .itinerary(let query, let travelerId):
            urlComponents.path = "/v1/traveler/\(travelerId)/itinerary"
            urlRequest.method = .get
                urlComponents.queryItems = []
                
                query.flights?.forEach({ (flight) in
                    urlComponents.queryItems?.append(URLQueryItem(name: "flight-ids", value: flight.id))
                })
                
                if let dateRange = query.dateRange {
                    urlComponents.queryItems?.append(URLQueryItem(name: "from", value: DateFormatter.withoutTimezone.string(from: dateRange.lowerBound)))
                    urlComponents.queryItems?.append(URLQueryItem(name: "to", value: DateFormatter.withoutTimezone.string(from: dateRange.upperBound)))
                }
        case .bookingPurchasedProductDetails(let query):
            urlComponents.path = "/v1/orderItemDetail/\(query.orderId)/booking/\(query.productId)"
        case .parkingPurchasedProductDetails(let query):
            urlComponents.path = "/v1/orderItemDetail/\(query.orderId)/parking/\(query.productId)"
        case .partnerPurchasedProductDetails(let query):
            urlComponents.path = "/v1/orderItemDetail/\(query.orderId)/menu/\(query.productId)"
        case .categories(let type):
            urlComponents.path = "/v1/category"
            urlRequest.method = .get

            urlComponents.queryItems = [
                URLQueryItem(name: "purchaseStrategy", value: type.rawValue)
            ]
        }
        
        urlRequest.url = urlComponents.url
        return urlRequest
    }
}
