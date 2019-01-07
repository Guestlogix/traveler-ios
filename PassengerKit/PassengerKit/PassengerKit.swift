//
//  PassengerKit.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-09-12.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public class PassengerKit {
    private let queue = OperationQueue()
    private let session: Session

    private static var _shared: PassengerKit?
    private static var shared: PassengerKit? {
        guard _shared != nil else {
            Log("SDK not initialized. Initialize the SDK using `PassengerKit.initialize(token:)` in your app delegate.", data: nil, level: .error)
            return nil
        }

        return _shared
    }

    public static func initialize(apiKey: String) {
        guard _shared == nil else {
            Log("SDK already initialized!", data: nil, level: .warning)
            return
        }

        _shared = PassengerKit(apiKey: apiKey)
    }

    init(apiKey: String) {
        self.session = Session(apiKey: apiKey)

        let sessionOperation = SessionBeginOperation(session: session)
        OperationQueue.authQueue.addOperation(sessionOperation)
    }

    func identify(_ identifier: String, attributes: [String: Any?]? = nil) {

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

    func checkAvailability(bookingContext: BookingContext, completion: @escaping (Error?) -> Void) {
        guard let date = bookingContext.selectedDate else {
            completion(BookingError.noDate)
            return
        }

        bookingContext.isReady = false

        let fetchOperation = AuthenticatedRemoteFetchOperation<[Availability]>(path: .productSchedule(bookingContext.product, from: date, to: date), session: session)
        let blockOperation = BlockOperation { [unowned fetchOperation] in
            bookingContext.availability = fetchOperation.resource?.first
            bookingContext.isReady = true
            completion(fetchOperation.error)
        }

        blockOperation.addDependency(fetchOperation)

        queue.addOperation(fetchOperation)
        OperationQueue.main.addOperation(blockOperation)
    }

    func fetchPasses(bookingContext: BookingContext, completion: @escaping ([Pass]?, Error?) -> Void) {
        guard let date = bookingContext.selectedDate else {
            completion(nil, BookingError.noDate)
            return
        }

        if bookingContext.requiresTime && bookingContext.selectedTime == nil {
            completion(nil, BookingError.noTime)
            return
        }

        let fetchOperation = AuthenticatedRemoteFetchOperation<[Pass]>(path: .passes(bookingContext.product, date: date, time: bookingContext.selectedTime), session: session)
        let blockOperation = BlockOperation { [unowned fetchOperation] in
            completion(fetchOperation.resource, fetchOperation.error)
        }

        blockOperation.addDependency(fetchOperation)

        queue.addOperation(fetchOperation)
        OperationQueue.main.addOperation(blockOperation)
    }

    // MARK: Public API

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

    public static func checkAvailability(bookingContext: BookingContext, completion: @escaping (Error?) -> Void) {
        shared?.checkAvailability(bookingContext: bookingContext, completion: completion)
    }

    public static func checkAvailability(bookingContext: BookingContext, delegate: AvailabilityCheckDelegate) {
        shared?.checkAvailability(bookingContext: bookingContext, completion: { [weak delegate] (error) in
            if let error = error {
                delegate?.availabilityCheckDidFailWith(error)
            } else {
                delegate?.availabilityCheckDidSucceedFor(bookingContext)
            }
        })
    }

    public static func fetchPasses(bookingContext: BookingContext, completion: @escaping ([Pass]?, Error?) -> Void) {
        shared?.fetchPasses(bookingContext: bookingContext, completion: completion)
    }

    public static func fetchPasses(bookingContext: BookingContext, delegate: PassFetchDelegate) {
        shared?.fetchPasses(bookingContext: bookingContext, completion: { [weak delegate] (passes, error) in
            if let passes = passes {
                delegate?.passFetchDidSucceedWith(passes)
            } else {
                delegate?.passFetchDidFailWith(error!)
            }
        })
    }
}
