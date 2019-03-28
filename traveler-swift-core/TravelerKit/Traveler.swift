//
//  Traveler.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-09-12.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public class Traveler {
    private let queue = OperationQueue()
    private let session: Session

    private static var _shared: Traveler?

    let device: Device

    static var shared: Traveler? {
        guard _shared != nil else {
            Log("SDK not initialized. Initialize the SDK using `Traveler.initialize(apiKey:)` in your app delegate.", data: nil, level: .error)
            return nil
        }

        return _shared
    }

    public static func initialize(apiKey: String, device: Device) {
        guard _shared == nil else {
            Log("SDK already initialized!", data: nil, level: .warning)
            return
        }

        _shared = Traveler(apiKey: apiKey, device: device)
    }

    init(apiKey: String, device: Device) {
        self.session = Session(apiKey: apiKey)
        self.device = device

        let sessionOperation = SessionBeginOperation(session: session)
        OperationQueue.authQueue.addOperation(sessionOperation)
    }

    func identify(_ identifier: String?, attributes: [String: Any?]? = nil) {
        self.session.identity = identifier
    }

    func flightSearch(query: FlightQuery, completion: @escaping ([Flight]? , Error?) -> Void) {
        let fetchOperation = AuthenticatedRemoteFetchOperation<[Flight]>(path: .flights(query), session: session)
        let blockOperation = BlockOperation { [unowned fetchOperation] in
            completion(fetchOperation.resource, fetchOperation.error)
        }

        blockOperation.addDependency(fetchOperation)

        queue.addOperation(fetchOperation)
        OperationQueue.main.addOperation(blockOperation)
    }

    func fetchCatalog(query: CatalogQuery, completion: @escaping (Catalog?, Error?) -> Void) {
        let fetchOperation = AuthenticatedRemoteFetchOperation<Catalog>(path: .catalog(query), session: session)
        let blockOperation = BlockOperation { [unowned fetchOperation] in
            completion(fetchOperation.resource, fetchOperation.error)
        }

        blockOperation.addDependency(fetchOperation)

        queue.addOperation(fetchOperation)
        OperationQueue.main.addOperation(blockOperation)
    }

    func fetchCatalogItemDetails(_ catalogItem: CatalogItem, completion: @escaping (CatalogItemDetails?, Error?) -> Void) {
        let fetchOperation = AuthenticatedRemoteFetchOperation<CatalogItemDetails>(path: .catalogItem(catalogItem), session: session)
        let blockOperation = BlockOperation { [unowned fetchOperation] in
            completion(fetchOperation.resource, fetchOperation.error)
        }

        blockOperation.addDependency(fetchOperation)

        queue.addOperation(fetchOperation)
        OperationQueue.main.addOperation(blockOperation)
    }

    func fetchAvailabilities(product: Product, startDate: Date, endDate: Date, completion: @escaping ([Availability]?, Error?) -> Void) {
        let fetchOperation = AuthenticatedRemoteFetchOperation<[Availability]>(path: .productSchedule(product, from: startDate, to: endDate), session: session)
        let blockOperation = BlockOperation { [unowned fetchOperation] in
            completion(fetchOperation.resource, fetchOperation.error)
        }

        blockOperation.addDependency(fetchOperation)

        queue.addOperation(fetchOperation)
        OperationQueue.main.addOperation(blockOperation)
    }

    func fetchPasses(product: Product, availability: Availability, option: BookingOption?, completion: @escaping ([Pass]?, Error?) -> Void) {
        let fetchOperation = AuthenticatedRemoteFetchOperation<[Pass]>(path: .passes(product, availability: availability, option: option), session: session)
        let blockOperation = BlockOperation { [unowned fetchOperation] in
            completion(fetchOperation.resource, fetchOperation.error)
        }

        blockOperation.addDependency(fetchOperation)

        queue.addOperation(fetchOperation)
        OperationQueue.main.addOperation(blockOperation)
    }

    func fetchBookingForm(product: Product, passes: [Pass], completion: @escaping (BookingForm?, Error?) -> Void) {
        let fetchOperation = AuthenticatedRemoteFetchOperation<[QuestionGroup]>(path: .questions(product, passes: passes), session: session)
        let blockOperation = BlockOperation { [unowned fetchOperation] in
            if let groups = fetchOperation.resource {
                let bookingForm = BookingForm(product: product, passes: passes, questionGroups: groups)
                completion(bookingForm, nil)
            } else {
                completion(nil, fetchOperation.error)
            }
        }

        blockOperation.addDependency(fetchOperation)

        queue.addOperation(fetchOperation)
        OperationQueue.main.addOperation(blockOperation)
    }

    // TODO: Use an array Purchase as an interface instead of BookingForm
    func createOrder(bookingForm: BookingForm, completion: @escaping (Order?, Error?) -> Void) {
        let fetchOperation = AuthenticatedRemoteFetchOperation<Order>(path: .createOrder([bookingForm], travelerId: session.identity), session: session)
        let blockOperation = BlockOperation { [unowned fetchOperation] in
            completion(fetchOperation.resource, fetchOperation.error)
        }

        blockOperation.addDependency(fetchOperation)

        queue.addOperation(fetchOperation)
        OperationQueue.main.addOperation(blockOperation)
    }

    func processOrder(_ order: Order, payment: Payment, completion: @escaping (Receipt?, Error?) -> Void) {
        let fetchOperation = AuthenticatedRemoteFetchOperation<Order>(path: .processOrder(order, payment), session: session)
        let blockOperation = BlockOperation { [unowned fetchOperation] in
            if let order = fetchOperation.resource {
                let receipt = Receipt(order: order, payment: payment)

                completion(receipt, nil)
            } else {
                completion(nil, fetchOperation.error)
            }
        }

        blockOperation.addDependency(fetchOperation)

        queue.addOperation(fetchOperation)
        OperationQueue.main.addOperation(blockOperation)
    }

    // MARK: Public API

    public static func identify(_ identifier: String?, attributes: [String: Any?]) {
        shared?.identify(identifier, attributes: attributes)
    }

    public static func flightSearch(query: FlightQuery, delegate: FlightSearchDelegate) {
        shared?.flightSearch(query: query, completion: { [weak delegate] (flights, error) in
            if let flights = flights {
                delegate?.flightSearchDidSucceedWith(flights)
            } else {
                delegate?.flightSearchDidFailWith(error!)
            }
        })
    }

    public static func flightSearch(query: FlightQuery, completion: @escaping ([Flight]? , Error?) -> Void) {
        shared?.flightSearch(query: query, completion: completion)
    }

    public static func fetchCatalog(query: CatalogQuery, delegate: CatalogFetchDelegate) {
        shared?.fetchCatalog(query: query, completion: { [weak delegate] (catalog, error) in
            if let catalog = catalog {
                delegate?.catalogFetchDidSucceedWith(catalog)
            } else {
                delegate?.catalogFetchDidFailWith(error!)
            }
        })
    }

    public static func fetchCatalog(query: CatalogQuery, completion: @escaping (Catalog?, Error?) -> Void) {
        shared?.fetchCatalog(query: query, completion: completion)
    }

    public static func fetchCatalogItemDetails(_ catalogItem: CatalogItem, delegate: CatalogItemDetailsFetchDelegate) {
        shared?.fetchCatalogItemDetails(catalogItem, completion: { [weak delegate] (details, error) in
            if let details = details {
                delegate?.catalogItemDetailsFetchDidSucceedWith(details)
            } else {
                delegate?.catalogItemDetailsFetchDidFailWith(error!)
            }
        })
    }

    public static func fetchCatalogItemDetails(_ catalogItem: CatalogItem, completion: @escaping (CatalogItemDetails?, Error?) -> Void) {
        shared?.fetchCatalogItemDetails(catalogItem, completion: completion)
    }

    public static func fetchPasses(product: Product, availability: Availability, option: BookingOption?, completion: @escaping ([Pass]?, Error?) -> Void) {
        shared?.fetchPasses(product: product, availability: availability, option: option, completion: completion)
    }

    public static func fetchPasses(product: Product, availability: Availability, option: BookingOption?, delegate: PassFetchDelegate) {
        shared?.fetchPasses(product: product, availability: availability, option: option, completion: { [weak delegate] (passes, error) in
            if let passes = passes {
                delegate?.passFetchDidSucceedWith(passes)
            } else {
                delegate?.passFetchDidFailWith(error!)
            }
        })
    }

    public static func createOrder(bookingForm: BookingForm, delegate: OrderCreateDelegate) {
        shared?.createOrder(bookingForm: bookingForm, completion: { [weak delegate] (order, error) in
            if let order = order {
                delegate?.orderCreationDidSucceed(order)
            } else {
                delegate?.orderCreationDidFail(error!)
            }
        })
    }

    public static func createOrder(bookingForm: BookingForm, completion: @escaping (Order?, Error?) -> Void) {
        shared?.createOrder(bookingForm: bookingForm, completion: completion)
    }

    public static func processOrder(_ order: Order, payment: Payment, delegate: OrderProcessDelegate) {
        shared?.processOrder(order, payment: payment, completion: { [weak delegate] (receipt, error) in
            if let receipt = receipt {
                delegate?.order(order, didSucceedWithReceipt: receipt)
            } else {
                delegate?.order(order, didFailWithError: error!)
            }
        })
    }

    public static func processOrder(_ order: Order, payment: Payment, completion: @escaping (Receipt?, Error?) -> Void) {
        shared?.processOrder(order, payment: payment, completion: completion)
    }

    public static func fetchBookingForm(product: Product, passes: [Pass], completion: @escaping (BookingForm?, Error?) -> Void) {
        shared?.fetchBookingForm(product: product, passes: passes, completion: completion)
    }

    public static func fetchBookingForm(product: Product, passes: [Pass], delegate: BookingFormFetchDelegate) {
        shared?.fetchBookingForm(product: product, passes: passes, completion: { [weak delegate] (form, error) in
            if let error = error {
                delegate?.bookingFormFetchDidFailWith(error)
            } else {
                delegate?.bookingFormFetchDidSucceedWith(form!)
            }
        })
    }

    public static func fetchAvailabilities(product: Product, startDate: Date, endDate: Date, completion: @escaping ([Availability]?, Error?) -> Void) {
        shared?.fetchAvailabilities(product: product, startDate: startDate, endDate: endDate, completion: completion)
    }

    public static func fetchAvailabilities(product: Product, startDate: Date, endDate: Date, delegate: AvailabilitiesFetchDelegate) {
        shared?.fetchAvailabilities(product: product, startDate: startDate, endDate: endDate, completion: { [weak delegate] (availabilities, error) in
            if let error = error {
                delegate?.availabilitiesFetchDidFailWith(error)
            } else {
                delegate?.availabilitiesFetchDidSucceedWith(availabilities!)
            }
        })
    }
}
