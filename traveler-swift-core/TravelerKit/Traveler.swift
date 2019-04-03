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


    // TODO: Use a Range<Date> instead
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

    /**
     This method stores the identity of the traveler internally. Once this identity is set,
     all subsequent calls to the this facade will be tracked under this traveler's identity.

     - Paramters:
        - identifier: A unique string that you recieve from your own backend after it retrieves
            it using the partner API. Passing `nil` will clear the traveler identity from the SDK.
        - attributes: A `Dictionary<String, Any?>` of custom traveler attributes to keep for records.
     */

    public static func identify(_ identifier: String?, attributes: [String: Any?]) {
        shared?.identify(identifier, attributes: attributes)
    }

    /**
     Performs a flight search for the given query.

     - Paratemeters:
        - query: A `FlightQuery` to search for.
        - delegate: The `FlightSearchDelegate` that is notified of the results
     */

    public static func flightSearch(query: FlightQuery, delegate: FlightSearchDelegate) {
        shared?.flightSearch(query: query, completion: { [weak delegate] (flights, error) in
            if let flights = flights {
                delegate?.flightSearchDidSucceedWith(flights)
            } else {
                delegate?.flightSearchDidFailWith(error!)
            }
        })
    }

    /**
     Performs a flight search for the given query.

     - Parameters:
        - query: A `FligthQuery` to search for.
        - completion: A completion block that is called when search is finished.
    */

    public static func flightSearch(query: FlightQuery, completion: @escaping ([Flight]? , Error?) -> Void) {
        shared?.flightSearch(query: query, completion: completion)
    }

    /**
     Fetches the `Catalog` for the given query.

     - Parameters:
        - query: A `CatalogQuery` to fetch for.
        - delegate: A `CatalogFetchDelegate` that is notified of the results.
     */

    public static func fetchCatalog(query: CatalogQuery, delegate: CatalogFetchDelegate) {
        shared?.fetchCatalog(query: query, completion: { [weak delegate] (catalog, error) in
            if let catalog = catalog {
                delegate?.catalogFetchDidSucceedWith(catalog)
            } else {
                delegate?.catalogFetchDidFailWith(error!)
            }
        })
    }

    /**
     Fetches the `Catalog` for the given query.

     - Parameters:
        - query: A `CatalogQuery` to fetch for.
        - completion: A completion block that is called when the results are ready.
     */

    public static func fetchCatalog(query: CatalogQuery, completion: @escaping (Catalog?, Error?) -> Void) {
        shared?.fetchCatalog(query: query, completion: completion)
    }

    /**
     Fetches the `CatalogItemDetails` for a given `CatalogItem`.

     - Parameters:
        - catalogItem: A `CatalogItem` for which to fetch the details.
        - delegate: A `CatalogItemDetailsFetchDelegate` that is notified of the results.
     */

    public static func fetchCatalogItemDetails(_ catalogItem: CatalogItem, delegate: CatalogItemDetailsFetchDelegate) {
        shared?.fetchCatalogItemDetails(catalogItem, completion: { [weak delegate] (details, error) in
            if let details = details {
                delegate?.catalogItemDetailsFetchDidSucceedWith(details)
            } else {
                delegate?.catalogItemDetailsFetchDidFailWith(error!)
            }
        })
    }

    /**
     Fetches the `CatalogItemDetails` for a given `CatalogItem`.

     - Parameters:
        - catalogItem: A `CatalogItem` for which to fetch the details.
        - delegate: A completion block that is called when the results are ready.
     */

    public static func fetchCatalogItemDetails(_ catalogItem: CatalogItem, completion: @escaping (CatalogItemDetails?, Error?) -> Void) {
        shared?.fetchCatalogItemDetails(catalogItem, completion: completion)
    }

    /**
     Fetches the `Pass`es associatd with a given a `Product` for a given `Availability` and `BookingOption`.

     - Paramaters:
        - product: The `Product` for which to fetch the passes for.
        - availability: The `Availability` for that Product to fetch the passes for.
        - option: An optional `BookingOption` to fetch passes for.
        - completion: A completion block that is called when the results are ready.
     */

    public static func fetchPasses(product: Product, availability: Availability, option: BookingOption?, completion: @escaping ([Pass]?, Error?) -> Void) {
        shared?.fetchPasses(product: product, availability: availability, option: option, completion: completion)
    }

    /**
     Fetches the `Pass`es associatd with a given a `Product` for a given `Availability` and `BookingOption`.

     - Paramaters:
        - product: The `Product` for which to fetch the passes for.
        - availability: The `Availability` for that Product to fetch the passes for.
        - option: An optional `BookingOption` to fetch passes for.
        - delegate: A `PassFetchDelegate` that is notified of the results.
     */

    public static func fetchPasses(product: Product, availability: Availability, option: BookingOption?, delegate: PassFetchDelegate) {
        shared?.fetchPasses(product: product, availability: availability, option: option, completion: { [weak delegate] (passes, error) in
            if let passes = passes {
                delegate?.passFetchDidSucceedWith(passes)
            } else {
                delegate?.passFetchDidFailWith(error!)
            }
        })
    }

    /**
     Creates an `Order` for the supplied `BookingForm`.

     - Parameters:
        - bookingForm: A `BookingForm` for which to create the `Order` for.
        - delgate: An `OrderCreateDelegate` that is notified of the results.
     */

    public static func createOrder(bookingForm: BookingForm, delegate: OrderCreateDelegate) {
        shared?.createOrder(bookingForm: bookingForm, completion: { [weak delegate] (order, error) in
            if let order = order {
                delegate?.orderCreationDidSucceed(order)
            } else {
                delegate?.orderCreationDidFail(error!)
            }
        })
    }

    /**
     Creates an `Order` for the supplied `BookingForm`.

     - Parameters:
        - bookingForm: A `BookingForm` for which to create the `Order` for.
        - completion: A completion block that is called when the results are ready.
     */

    public static func createOrder(bookingForm: BookingForm, completion: @escaping (Order?, Error?) -> Void) {
        shared?.createOrder(bookingForm: bookingForm, completion: completion)
    }

    /**
     Processes the `Payment` for given `Order`.

     - Parameters:
        - order: The `Order` to process.
        - payment: The `Payment` instance that holds the payment information.
        - delegate: An `OrderProcessDelegate` that is notified of the results.
     */

    public static func processOrder(_ order: Order, payment: Payment, delegate: OrderProcessDelegate) {
        shared?.processOrder(order, payment: payment, completion: { [weak delegate] (receipt, error) in
            if let receipt = receipt {
                delegate?.order(order, didSucceedWithReceipt: receipt)
            } else {
                delegate?.order(order, didFailWithError: error!)
            }
        })
    }

    /**
     Processes the `Payment` for given `Order`.

     - Parameters:
        - order: The `Order` to process.
        - payment: The `Payment` instance that holds the payment information.
        - completion: A completion block that is called when the results are ready.
     */

    public static func processOrder(_ order: Order, payment: Payment, completion: @escaping (Receipt?, Error?) -> Void) {
        shared?.processOrder(order, payment: payment, completion: completion)
    }

    /**
     Fetches the `BookingForm` for a given `Product` and array of `Pass`es.

     - Parameters:
        - product: A `Product` for which to fetch the `BookingForm`.
        - passes: An `Array<Pass>` for which to fetch the `BookingForm`.
        - completion: A completion block that is called when the results are ready.
     */

    public static func fetchBookingForm(product: Product, passes: [Pass], completion: @escaping (BookingForm?, Error?) -> Void) {
        shared?.fetchBookingForm(product: product, passes: passes, completion: completion)
    }

    /**
     Fetches the `BookingForm` for a given `Product` and array of `Pass`es.

     - Parameters:
        - product: A `Product` for which to fetch the `BookingForm`.
        - passes: An `Array<Pass>` for which to fetch the `BookingForm`.
        - delegate: A `BookingFormFetchDelegate` that is notified of the results.
     */

    public static func fetchBookingForm(product: Product, passes: [Pass], delegate: BookingFormFetchDelegate) {
        shared?.fetchBookingForm(product: product, passes: passes, completion: { [weak delegate] (form, error) in
            if let error = error {
                delegate?.bookingFormFetchDidFailWith(error)
            } else {
                delegate?.bookingFormFetchDidSucceedWith(form!)
            }
        })
    }

    /**
     Fetches an `Array<Availability>` that represents all the available dates
     between the given start and end date for a given `Product`.

     - Parameters:
        - product: The `Product` for which to fetch the availabilities for.
        - startDate: The lower bound of the date range for which to fetch availabilities for.
        - endDate: The upper bound of the date range for which to fetch availabilties for.
        - completion: A completion block that is called when the results are ready.
     */

    public static func fetchAvailabilities(product: Product, startDate: Date, endDate: Date, completion: @escaping ([Availability]?, Error?) -> Void) {
        shared?.fetchAvailabilities(product: product, startDate: startDate, endDate: endDate, completion: completion)
    }

    /**
     Fetches an `Array<Availability>` that represents all the available dates
     between the given start and end date for a given `Product`.

     - Parameters:
        - product: The `Product` for which to fetch the availabilities for.
        - startDate: The lower bound of the date range for which to fetch availabilities for.
        - endDate: The upper bound of the date range for which to fetch availabilties for.
        - delegate: A `AvailaibilitiesFetchDelegate` that is notified of the results.
     */

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
