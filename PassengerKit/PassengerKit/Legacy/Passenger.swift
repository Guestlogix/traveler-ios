//
//  Passenger.swift
//  Guestlogix
//
//  Created by TribalScale on 4/26/18.
//  Copyright © 2018 TribalScale. All rights reserved.
//

import Foundation

// MARK: - Passenger

protocol Passenger {
    
    func setSessionToken(_ token: Token)
    
    // MARK: - /auth
    
    func authenticate(_ credentials: Credentials, completion: @escaping (Token?, PassengerApi.PassengerError?) -> Void)
    
    func forgotPassword(for username: String, completion: @escaping (PassengerApi.PassengerError?) -> Void)
    
    func resetPassword(_ password: String, token: String, completion: @escaping (PassengerApi.PassengerError?) -> Void)
    
    // MARK: - /user
    
    func create(_ user: UserCreate, completion: @escaping (Identifier?, PassengerApi.PassengerError?) -> Void)
    
    func getUser(completion: @escaping (User?, PassengerApi.PassengerError?) -> Void)
    
    func modify(_ user: UserUpdate, completion: @escaping (PassengerApi.PassengerError?) -> Void)
    
    func modify(_ password: String, completion: @escaping (PassengerApi.PassengerError?) -> Void)

    /*

    func create(_ paymentMethod: PaymentMethodCreate, completion: @escaping (PassengerApi.PassengerError?) -> Void)
    
    func getPaymentMethod(ofType type: PaymentType, completion: @escaping (PaymentMethod?, PassengerApi.PassengerError?) -> Void)
    
    func deletePaymentMethod(withIdentifier identifier: String, ofType type: PaymentType , completion: @escaping (PassengerApi.PassengerError?) -> Void)

    // MARK: - /trip
    
    func getTrips(_ tripNumber: String, _ carrierCode: String, _ departureDate: DepartureDate, completion: @escaping ([Trip]?, PassengerApi.PassengerError?) -> Void)
    
    func getProducts(for trip: Trip, travelClass: TravelClass?, completion: @escaping ([TripProduct], PassengerApi.PassengerError?) -> Void)
    
    func getTravelClasses(for trip: Trip, completion: @escaping ([TravelClass], PassengerApi.PassengerError?) -> Void)
    
    func getPromotions(for products: [TripProduct], from trip: Trip, travelClass: TravelClass?, completion: @escaping ([TripPromotion], PassengerApi.PassengerError?) -> Void)
    
    // MARK: - /product
    
    func getProducts(for company: Company, completion: @escaping ([Product], PassengerApi.PassengerError?) -> Void)
    
    // MARK: - /image
    
    func getImage(byId id: String, withResolution resolution: Resolution, completion: @escaping (Data?, PassengerApi.PassengerError?) -> Void)
    
    // MARK: - /company
    
    func getCompanies(completion: @escaping ([Company], PassengerApi.PassengerError?) -> Void)
    
    // MARK: - /order
    
    func create(_ order: OrderCreate, completion: @escaping (Identifier?, PassengerApi.PassengerError?) -> Void)
    
    func getOrders(completion: @escaping ([Order], PassengerApi.PassengerError?) -> Void)
    
    func getOrder(with identifier: String, completion: @escaping (Order?, PassengerApi.PassengerError?) -> Void)
    
    func modifyOrderStatus(_ status: Order.Status, for orderIdentifier: String, completion: @escaping (PassengerApi.PassengerError?) -> Void)
    
    func cancelAllPendingOrders(for tripIdentifier: Identifier, completion: @escaping (PassengerApi.PassengerError?) -> Void)
    
    func getOrderPendingRating(completion: @escaping (Order?, PassengerApi.PassengerError?) -> Void)
    
    func rateOrder(withIdentifier identifier: String, _ rating: Order.Rating, completion: @escaping (PassengerApi.PassengerError?) -> Void)
    */
}

class PassengerApi: Passenger {
    
    enum PassengerError: Error {
        case generic
        case server(code: Int, message: String)
        case decoding(message: String)

        init(_ error: Error) {
            switch error {
            case NetworkError.clientError(_, let data?),
                 NetworkError.serverError(_, let data?):

                do {
                    let apiError = try JSONDecoder().decode(PassengerApiError.self, from: data)
                    self = .server(code: apiError.code, message: apiError.message)
                } catch {
                    self = .generic
                }
            case is DecodingError:
                self = .decoding(message: error.localizedDescription)
            default:
                self = .generic
            }
        }
    }

    private var token: Token?
    private let queue = OperationQueue()

    func setSessionToken(_ token: Token) {
        self.token = token
    }

    func authenticate(_ credentials: Credentials, completion: @escaping (Token?, PassengerApi.PassengerError?) -> Void) {

    }

    func forgotPassword(for username: String, completion: @escaping (PassengerApi.PassengerError?) -> Void) {

    }

    func resetPassword(_ password: String, token: String, completion: @escaping (PassengerApi.PassengerError?) -> Void) {

    }

    func getUser(completion: @escaping (User?, PassengerApi.PassengerError?) -> Void) {
        guard let token = token else {
            completion(nil, .generic)
            return
        }


    }

    func modify(_ password: String, completion: @escaping (PassengerApi.PassengerError?) -> Void) {
        guard let token = token else {
            completion(.generic)
            return
        }


    }

    func create(_ user: UserCreate, completion: @escaping (Identifier?, PassengerApi.PassengerError?) -> Void) {

    }

    func modify(_ user: UserUpdate, completion: @escaping (PassengerApi.PassengerError?) -> Void) {
        guard let token = token else {
            completion(.generic)
            return
        }

    }
}
