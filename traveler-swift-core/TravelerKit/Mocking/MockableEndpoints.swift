//
//  MockableEndpoints.swift
//  TravelerKitTests
//
//  Created by Omar Padierna on 2019-10-26.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public enum MockableEndpoints: String, CaseIterable {
    case auth = "/v1/auth/token"
    case flight = "/v1/flight"
    case booking = "/v1/booking/item"
    case catalogGroup = "/v1/catalog-group"
    case order = "/v1/order"
    case search = "/v1/booking"
    case wishlist = "/v1/travelerId/wishlist"
    case cancellation = "/v1/order/String/cancellation"
    case bookingSchedule = "/v1/product/12345/schedule"
    case bookingPass = "/v1/product/12345/pass"
    case bookingQuestion = "/v1/product/12345/question"
    
    var data: Data {
        switch self {
        case .auth:
            return MockResponses.auth().jsonData()
        case .flight:
            return MockResponses.flight().jsonData()
        case .booking:
            return MockResponses.bookingItemDetails().jsonData()
        case .catalogGroup:
            return MockResponses.catalog().jsonData()
        case .order:
            return MockResponses.orders().jsonData()
        case .search:
            return MockResponses.search().jsonData()
        case .wishlist:
            return MockResponses.wishlist().jsonData()
        case .cancellation:
            return MockResponses.cancellation().jsonData()
        case .bookingSchedule:
            return MockResponses.bookingSchedule().jsonData()
        case .bookingPass:
            return MockResponses.bookingPass().jsonData()
        case .bookingQuestion:
            return MockResponses.bookingQuestion().jsonData()
        }
    }
    
    init?(url: URL?) {
        guard let url = url else {
            return nil
        }
        
        if let endpoint = MockableEndpoints(rawValue: url.path) {
            self = endpoint
        } else if url.path.contains("/wishlist") {
            self = .wishlist
        } else if url.path.contains("/cancellation") {
            self = .cancellation
        } else if url.path.contains("/schedule") {
            self = .bookingSchedule
        } else if url.path.contains("/pass") {
            self = .bookingPass
        } else if url.path.contains("/question") {
            self = .bookingQuestion
        } else if url.path.contains("/v1/booking") {
            self = .booking
        } else {
            return nil
        }
    }
}
