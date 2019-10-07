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
    private let serialQueue = OperationQueue()
    private let session: Session

    private static var _shared: Traveler?

    let device: Device
    let sandboxMode: Bool

    static var shared: Traveler? {
        guard _shared != nil else {
            Log("SDK not initialized. Initialize the SDK using `Traveler.initialize(apiKey:)` in your app delegate.", data: nil, level: .error)
            return nil
        }

        return _shared
    }

    public static func initialize(apiKey: String, device: Device, sandboxMode: Bool = false) {
        guard _shared == nil else {
            Log("SDK already initialized!", data: nil, level: .warning)
            return
        }

        _shared = Traveler(apiKey: apiKey, device: device, sandboxMode: sandboxMode)
    }

    init(apiKey: String, device: Device, sandboxMode: Bool) {
        self.session = Session(apiKey: apiKey)
        self.device = device
        self.serialQueue.maxConcurrentOperationCount = 1
        self.sandboxMode = sandboxMode
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

    func fetchCatalogItemDetails(_ productItem: Product, completion: @escaping (CatalogItemDetails?, Error?) -> Void) {
        let fetchOperation: AuthenticatedRemoteFetchOperation<AnyItemDetails>
        if let travelerProfileId = session.identity {
            fetchOperation = AuthenticatedRemoteFetchOperation<AnyItemDetails>(path: .catalogItem(productItem, travelerId: travelerProfileId, type: productItem.type), session: session)
        } else {
            fetchOperation = AuthenticatedRemoteFetchOperation<AnyItemDetails>(path: .catalogItem(productItem, travelerId: nil, type: productItem.type), session: session)
        }
        let blockOperation = BlockOperation { [unowned fetchOperation] in
            completion(fetchOperation.resource?.payload, fetchOperation.error)
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

    func fetchPasses(product: BookingItemDetails, availability: Availability, option: BookingOption?, completion: @escaping ([Pass]?, Error?) -> Void) {
        let fetchOperation = AuthenticatedRemoteFetchOperation<[Pass]>(path: .passes(product, availability: availability, option: option), session: session)
        let blockOperation = BlockOperation { [unowned fetchOperation] in
            completion(fetchOperation.resource, fetchOperation.error)
        }

        blockOperation.addDependency(fetchOperation)

        queue.addOperation(fetchOperation)
        OperationQueue.main.addOperation(blockOperation)
    }

    func fetchBookingForm(product: BookingItemDetails, passes: [Pass], completion: @escaping (BookingForm?, Error?) -> Void) {
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

    func fetchOrders(_ query: OrderQuery, identifier: AnyHashable?, previousResultBlock: (() -> OrderResult?)?, resultBlock: ((OrderResult, AnyHashable?) -> Void)?, completion: @escaping (OrderResult?, Error?, AnyHashable?) -> Void) {
        guard let travelerProfileId = session.identity else {
            completion(nil, OrderResultError.unidentifiedTraveler, identifier)
            return
        }

        class ResultWrapper {
            var result: OrderResult?
        }

        let wrapper = ResultWrapper()

        let fetchOperation = AuthenticatedRemoteFetchOperation<OrderResult>(path: .orders(query, travelerId: travelerProfileId), session: session)
        let mergeOperation = BlockOperation { [unowned fetchOperation] in
            guard let result = fetchOperation.resource else { return }

            wrapper.result = previousResultBlock?()?.merge(result) ?? result
            resultBlock?(wrapper.result!, identifier)
        }

        let blockOperation = BlockOperation { [unowned fetchOperation] in
            if let result = wrapper.result {
                completion(result, nil, identifier)
            } else {
                completion(nil, fetchOperation.error!, identifier)
            }
        }

        mergeOperation.addDependency(fetchOperation)
        blockOperation.addDependency(mergeOperation)

        queue.addOperation(fetchOperation)
        serialQueue.addOperation(mergeOperation)
        OperationQueue.main.addOperation(blockOperation)
    }

    func fetchCancellationQuote(order: Order, completion: @escaping (CancellationQuote?, Error?) -> Void) {
        let fetchOperation = AuthenticatedRemoteFetchOperation<CancellationQuoteResponse>(path: .cancellationQuote(order), session: session)
        let blockOperation = BlockOperation { [unowned fetchOperation] in
            completion(fetchOperation.resource.flatMap({ CancellationQuote(cancellationQuoteResponse: $0, order: order) }), fetchOperation.error)
        }

        blockOperation.addDependency(fetchOperation)

        queue.addOperation(fetchOperation)
        OperationQueue.main.addOperation(blockOperation)
    }

    func cancelOrder(quote: CancellationQuote, competion: @escaping (Order?, Error?) -> Void) {
        guard quote.expirationDate > Date() else {
            competion(nil, CancellationError.expiredQuote)
            return
        }

        let fetchOperation = AuthenticatedRemoteFetchOperation<Order>(path: .cancelOrder(quote), session: session)
        let blockOperation = BlockOperation { [unowned fetchOperation] in
            competion(fetchOperation.resource, fetchOperation.error)
        }

        blockOperation.addDependency(fetchOperation)

        queue.addOperation(fetchOperation)
        OperationQueue.main.addOperation(blockOperation)
    }

    func emailOrderConfirmation(order: Order, completion: @escaping (Error?) -> Void) {
        let requestOperation = AuthenticatedRemoteRequestOperation(path: .emailOrderConfirmation(order), session: session)
        let blockOperation = BlockOperation { [unowned requestOperation] in
            completion(requestOperation.error)
        }

        blockOperation.addDependency(requestOperation)

        queue.addOperation(requestOperation)
        OperationQueue.main.addOperation(blockOperation)
    }

    @discardableResult
    func wishlistRemove(items: [Product], result: WishlistResult?, completion: @escaping(WishlistResult?, Error?) -> Void) -> WishlistResult? {
        guard let travelerProfileId = session.identity else {
            completion(nil, WishlistToggleError.unidentifiedTraveler)
            return nil
        }

        var immediateResult: WishlistResult?

        if var result = result, let items = items as? [ProductItem] {
            let allItemsExistInResult = items.map({ $0.id }).reduce(true) { (exists, id) -> Bool in
                exists && result.items.values.contains(where: { (item) -> Bool in
                    item.id == id
                })
            }

            guard allItemsExistInResult == true else {
                completion(nil, WishlistToggleError.notInWishlist)
                return nil
            }

            for item in items {
                result.remove(item)
            }

            immediateResult = result
        }

        let fetchOperation = AuthenticatedRemoteFetchOperation<[ProductItem]>(path: .wishlistToggle(items, travelerId: travelerProfileId), session: session)
        let blockOperation = BlockOperation { [unowned fetchOperation] in
            completion(result, fetchOperation.error)
        }

        blockOperation.addDependency(fetchOperation)
        queue.addOperation(fetchOperation)
        OperationQueue.main.addOperation(blockOperation)

        return immediateResult
    }

    func wishlistAdd(items: [Product], completion: @escaping([ProductItem]?, Error?) -> Void) {
        guard let travelerProfileId = session.identity else {
            completion(nil, WishlistToggleError.unidentifiedTraveler)
            return
        }

        let fetchOperation = AuthenticatedRemoteFetchOperation<[ProductItem]>(path: .wishlistToggle(items, travelerId: travelerProfileId), session: session)
        let blockOperation = BlockOperation { [unowned fetchOperation] in
            completion(fetchOperation.resource, fetchOperation.error)
        }

        blockOperation.addDependency(fetchOperation)
        queue.addOperation(fetchOperation)
        OperationQueue.main.addOperation(blockOperation)
    }

    func fetchWishlist(_ query: WishlistQuery, identifier: AnyHashable?, previousResultBlock: (() -> WishlistResult?)?, resultBlock: ((WishlistResult, AnyHashable?) -> Void)?, completion: @escaping (WishlistResult?, Error?, AnyHashable?) -> Void) {
        guard let travelerProfileId = session.identity else {
            completion(nil, WishlistResultError.unidentifiedTraveler, identifier)
            return
        }

        class ResultWrapper {
            var result: WishlistResult?
        }

        let wrapper = ResultWrapper()

        let fetchOperation = AuthenticatedRemoteFetchOperation<WishlistResult>(path: .wishlist(query, travelerId: travelerProfileId) , session: session)
        let mergeOperation = BlockOperation { [unowned fetchOperation] in
            guard let result = fetchOperation.resource else { return }

            wrapper.result = previousResultBlock?()?.merge(result) ?? result
            resultBlock?(wrapper.result!, identifier)
        }

        let blockOperation = BlockOperation { [unowned fetchOperation] in
            if let result = wrapper.result {
                completion(result, nil, identifier)
            } else {
                completion(nil, fetchOperation.error!, identifier)
            }
        }

        mergeOperation.addDependency(fetchOperation)
        blockOperation.addDependency(mergeOperation)

        queue.addOperation(fetchOperation)
        serialQueue.addOperation(mergeOperation)
    OperationQueue.main.addOperation(blockOperation)

    }

    func searchBookingItems(_ searchQuery: BookingItemQuery, identifier: AnyHashable?, previousResultBlock: (() -> BookingItemSearchResult?)?, resultBlock: ((BookingItemSearchResult, AnyHashable?) -> Void)?, completion: @escaping (BookingItemSearchResult?, Error?, AnyHashable?) -> Void) {

        if searchQuery.boundingBox == nil && searchQuery.categories == nil && searchQuery.range == nil && searchQuery.text == nil {
            completion(nil , SearchQueryError.invalidQuery, nil)
        } else {

            class ResultWrapper {
                var result: BookingItemSearchResult?
            }

            let wrapper = ResultWrapper()

            let fetchOperation = AuthenticatedRemoteFetchOperation<BookingItemSearchResult>(path: .searchBookingItems(searchQuery), session: session)
            let mergeOperation = BlockOperation { [unowned fetchOperation] in
                guard let result = fetchOperation.resource else { return }

                wrapper.result = previousResultBlock?()?.merge(result) ?? result
                resultBlock?(wrapper.result!, identifier)
            }

            let blockOperation = BlockOperation { [unowned fetchOperation] in
                if let result = wrapper.result {
                    completion(result, nil, identifier)
                } else {
                    completion(nil, fetchOperation.error!, identifier)
                }
            }

            mergeOperation.addDependency(fetchOperation)
            blockOperation.addDependency(mergeOperation)

            queue.addOperation(fetchOperation)
            serialQueue.addOperation(mergeOperation)
            OperationQueue.main.addOperation(blockOperation)
        }
    }

    func searchParkingItems(_ searchQuery: ParkingItemQuery, identifier: AnyHashable?, previousResultBlock: (() -> ParkingItemSearchResult?)?, resultBlock: ((ParkingItemSearchResult, AnyHashable?) -> Void)?, completion: @escaping (ParkingItemSearchResult?, Error?, AnyHashable?) -> Void) {

        class ResultWrapper {
            var result: ParkingItemSearchResult?

        }

            let wrapper = ResultWrapper()

            let fetchOperation = AuthenticatedRemoteFetchOperation<ParkingItemSearchResult>(path: .searchParkingItems(searchQuery), session: session)
            let mergeOperation = BlockOperation { [unowned fetchOperation] in
                guard let result = fetchOperation.resource else { return }

                wrapper.result = previousResultBlock?()?.merge(result) ?? result
                resultBlock?(wrapper.result!, identifier)
            }

            let blockOperation = BlockOperation { [unowned fetchOperation] in
                if let result = wrapper.result {
                    completion(result, nil, identifier)
                } else {
                    completion(nil, fetchOperation.error!, identifier)
                }
            }

            mergeOperation.addDependency(fetchOperation)
            blockOperation.addDependency(mergeOperation)

            queue.addOperation(fetchOperation)
            serialQueue.addOperation(mergeOperation)
            OperationQueue.main.addOperation(blockOperation)

    }

    // MARK: Public API

    /**
     This method stores the identity of the traveler internally. Once this identity is set,
     all subsequent calls to the this facade will be tracked under this traveler's identity.

     - Parameters:
        - identifier: A unique string that you recieve from your own backend after it retrieves
            it using the partner API. Passing `nil` will clear the traveler identity from the SDK.
        - attributes: A `Dictionary<String, Any?>` of custom traveler attributes to keep for records.
     */

    public static func identify(_ identifier: String?, attributes: [String: Any?]) {
        shared?.identify(identifier, attributes: attributes)
    }

    /**
     Performs a flight search for the given query.

     - Parameters:
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
        - query: A `FlightQuery` to search for.
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
        - catalogItem: A `Product` for which to fetch the details.
        - delegate: A `CatalogItemDetailsFetchDelegate` that is notified of the results.
     */

    public static func fetchCatalogItemDetails(_ catalogItem: Product, delegate: CatalogItemDetailsFetchDelegate) {
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
        - catalogItem: A `Product` for which to fetch the details.
        - delegate: A completion block that is called when the results are ready.
     */

    public static func fetchCatalogItemDetails(_ catalogItem: Product, completion: @escaping (CatalogItemDetails?, Error?) -> Void) {
        shared?.fetchCatalogItemDetails(catalogItem, completion: completion)
    }

    /**
     Fetches the `Pass`es associated with a given `Product` for a given `Availability` and `BookingOption`.

     - Parameters:
        - product: The `Product` for which to fetch the passes for.
        - availability: The `Availability` for that Product to fetch the passes for.
        - option: An optional `BookingOption` to fetch passes for.
        - completion: A completion block that is called when the results are ready.
     */

    public static func fetchPasses(product: BookingItemDetails, availability: Availability, option: BookingOption?, completion: @escaping ([Pass]?, Error?) -> Void) {
        shared?.fetchPasses(product: product, availability: availability, option: option, completion: completion)
    }

    /**
     Fetches the `Pass`es associated with a given `Product` for a given `Availability` and `BookingOption`.

     - Parameters:
        - product: The `Product` for which to fetch the passes for.
        - availability: The `Availability` for that Product to fetch the passes for.
        - option: An optional `BookingOption` to fetch passes for.
        - delegate: A `PassFetchDelegate` that is notified of the results.
     */

    public static func fetchPasses(product: BookingItemDetails, availability: Availability, option: BookingOption?, delegate: PassFetchDelegate) {
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

    public static func fetchBookingForm(product: BookingItemDetails, passes: [Pass], completion: @escaping (BookingForm?, Error?) -> Void) {
        shared?.fetchBookingForm(product: product, passes: passes, completion: completion)
    }

    /**
     Fetches the `BookingForm` for a given `Product` and array of `Pass`es.

     - Parameters:
        - product: A `Product` for which to fetch the `BookingForm`.
        - passes: An `Array<Pass>` for which to fetch the `BookingForm`.
        - delegate: A `BookingFormFetchDelegate` that is notified of the results.
     */

    public static func fetchBookingForm(product: BookingItemDetails, passes: [Pass], delegate: BookingFormFetchDelegate) {
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

    /**
     Fetches an `OrderResult` corresponding to the given `OrderQuery`.

     - Parameters:
     - query: The `OrderQuery` to filter.
     - identifier: An optional hash identifying the request. This value is returned back in the delegates. Use this to distinguish between different requests
     - delegate: An `OrderFetchDelegate` that is notified of the results.
     */

    public static func fetchOrders(_ query: OrderQuery, identifier: AnyHashable?, delegate: OrderFetchDelegate) {
        shared?.fetchOrders(query, identifier: identifier, previousResultBlock: { [weak delegate] () -> OrderResult? in
            return delegate?.previousResult()
            }, resultBlock: { [weak delegate] (result, identifier) in
                delegate?.orderFetchDidReceive(result, identifier: identifier)
            }, completion: { [weak delegate] (result, error, identifier) in
                if let error = error {
                    delegate?.orderFetchDidFailWith(error, identifier: identifier)
                } else {
                    delegate?.orderFetchDidSucceedWith(result!, identifier: identifier)
                }
        })
    }

    /**
     Fetches an `OrderResult` corresponding to the given `OrderQuery`.

     - Parameters:
     - query: The `OrderQuery` to filter.
     - identifier: An optional hash identifying the request. This value is returned back in the callbacks. Use this to distinguish between different requests
     - previousResultBlock: A block called (on a worker thread) to return any previous results that are to be merged
     - resultBlock: A block called (on a worker thread) with the final merged results
     - completion: A completion block that is called when the results are ready.
     */

    public static func fetchOrders(_ query: OrderQuery, identifier: AnyHashable?, previousResultBlock: (() -> OrderResult?)?, resultBlock: ((OrderResult, AnyHashable?) -> Void)?, completion: @escaping (OrderResult?, Error?, AnyHashable?) -> Void) {
        shared?.fetchOrders(query, identifier: identifier, previousResultBlock: previousResultBlock, resultBlock: resultBlock, completion: completion)
    }

    /**
     Fetches a `CancellationQuote` for a given `Order`

     - Parameters:
     - order: The `Order` for which to get a quote
     - delegate: A `CancellationQuoteFetchDelegate` that is notified of the results.
    */

    public static func fetchCancellationQuote(order: Order, delegate: CancellationQuoteFetchDelegate) {
        shared?.fetchCancellationQuote(order: order, completion: { [weak delegate] (quote, error) in
            if let error = error {
                delegate?.cancellationQuoteFetchDidFailWith(error)
            } else {
                delegate?.cancellationQuoteFetchDidSucceedWith(quote!)
            }
        })
    }

    /**
     Fetches a `CancellationQuote` for a given `Order`

     - Parameters:
     - order: The `Order` for which to get a quote
     - completion: A completion block that is called when the results are ready
     */

    public static func fetchCancellationQuote(order: Order, completion: @escaping (CancellationQuote?, Error?) -> Void) {
        shared?.fetchCancellationQuote(order: order, completion: completion)
    }

    /**
     Cancels an `Order`, given the `CancellationQuote`

     - Parameters:
     - quote: The `CancellationQuote` corresponding to the `Order` that is to be cancelled
     - delegate: A `CancellationDelegate` that is notified of the results
        A `CancellationError.expiredQuote` will be thrown if the quote has expired.
     */

    public static func cancelOrder(quote: CancellationQuote, delegate: CancellationDelegate) {
        shared?.cancelOrder(quote: quote, competion: { [weak delegate] (order, error) in
            if let error = error {
                delegate?.cancellationDidFailWith(error)
            } else {
                delegate?.cancellationDidSucceed(order: order!)
            }
        })
    }

    /**
     Cancels an `Order`, given the `CancellationQuote`

     - Parameters:
     - quote: The `CancellationQuote` corresponding to the `Order` that is to be cancelled
     - completion: A completion block that is called when the results are ready.
        A `CancellationError.expiredQuote` will be thrown if the quote has expired.
     */

    public static func cancelOrder(quote: CancellationQuote, completion: @escaping (Order?, Error?) -> Void) {
        shared?.cancelOrder(quote: quote, competion: completion)
    }

    /**
     Emails order confirmation to email used in purchase, given the `Order`

     - Parameters:
     - order: The `Order` with the tickets to be sent
     - delegate: A `EmailTicketsDelegate` that is notified if the tickets were sent successfuly
    */

    public static func emailOrderConfirmation(order: Order, delegate: EmailOrderConfirmationDelegate) {
        shared?.emailOrderConfirmation(order: order, completion: { [weak delegate] (error) in
            if let error = error {
                delegate?.emailDidFailWith(error)
            } else {
                delegate?.emailDidSucceed()
            }
        })
    }

    /**
     Emails order confirmation to email used in purchase, given the `Order`

     - Parameters:
     - order: The `Order` with the tickets to be sent
     - completion: A completion block that is called when the email is sent
     */

    public static func emailOrderConfirmation(order: Order, completion: @escaping (Error?) -> Void) {
        shared?.emailOrderConfirmation(order: order, completion: completion)
    }

    /**
<<<<<<< HEAD
     Adds the given `CatalogItem` into the traveler's wishlist

     - Parameters:
     - item: The `CatalogItem` that needs to be wishlisted
     - delegate: A `WishlistAddDelegate` that is notified if the item was wishlisted successfuly
     */

    public static func wishlistAdd(_ items: [Product], delegate: WishlistAddDelegate) {
        shared?.wishlistAdd(items: items, completion: { [weak delegate] addedItems, error in
            if let error = error {
                delegate?.wishlistAddDidFailWith(error)
            } else {
                delegate?.wishlistAddDidSucceedFor(addedItems!)
            }
        })
    }

    /**
     Adds the given `CatalogItem`s into the traveler's wishlist

     - Parameters:
     - items: The `CatalogItem`s that need to be wishlisted
     - completion: A completion block that is called when the item is wishlisted
     */

    public static func wishlistAdd(_ items: [Product], completion: @escaping ([ProductItem]?, Error?) -> Void) {
        shared?.wishlistAdd(items: items, completion: completion)
    }

    /**
     Removes the given `CatalogItem` from the traveler's wishlist

     - Parameters:
     - item: The `CatalogItem` that needs to be removed from the wishlist
     - delegate: A `WishlistRemoveDelegate` that is notified if the item was removed from the wishlist successfuly
     */
    @discardableResult
    public static func wishlistRemove(_ items: [Product], result: WishlistResult?, delegate: WishlistRemoveDelegate) -> WishlistResult? {
        return shared?.wishlistRemove(items: items, result: result, completion: { [weak delegate] (result, error) in
            if let error = error {
                delegate?.wishlistRemoveDidFailWith(error, result: result)
            } else {
                delegate?.wishlistRemoveDidSucceed()
            }
        })
    }

    /**
     Removes the given `CatalogItem` from the traveler's wishlist

     - Parameters:
     - item: The `CatalogItem` that needs to be removed from the wishlist
     - completion: A completion block that is called when the item is removed from the wishlist
     */

    @discardableResult
    public static func wishlistRemove(_ items: [Product], result: WishlistResult?, completion: @escaping (WishlistResult?, Error?) -> Void) -> WishlistResult? {
        return shared?.wishlistRemove(items: items, result: result, completion: completion)
    }

    /**
     Fetches an `WishlistResult` corresponding to the given `WishlistQuery`.

     - Parameters:
     - query: The `WishlistQuery` to filter.
     - identifier: An optional hash identifying the request. This value is returned back in the delegates. Use this to distinguish between different requests
     - delegate: An `WishlistFetchDelegate` that is notified of the results.
     */

    public static func fetchWishlist(_ query: WishlistQuery, identifier: AnyHashable?, delegate: WishlistFetchDelegate) {
        shared?.fetchWishlist(query, identifier: identifier, previousResultBlock: { [weak delegate] () -> WishlistResult? in
            return delegate?.previousResult()
        }, resultBlock: { [weak delegate] (result, identifier) in
            delegate?.wishlistFetchDidReceive(result, identifier: identifier)
        }, completion: { [weak delegate] (result, error, identifier) in
            if let error = error {
                delegate?.wishlistFetchDidFailWith(error, identifier: identifier)
            } else {
                delegate?.wishlistFetchDidSucceedWith(result!, identifier: identifier)
            }
        })
    }

    /**
        Fetches an `WishlistResult` corresponding to the given `WishlistQuery`.

        - Parameters:
        - query: The `WishlistQuery` to filter.
        - identifier: An optional hash identifying the request. This value is returned back in the callbacks. Use this to distinguish between different requests
        - previousResultBlock: A block called (on a worker thread) to return any previous results that are to be merged
        - resultBlock: A block called (on a worker thread) with the final merged results
        - completion: A completion block that is called when the results are ready.
        */

       public static func fetchWishlist(_ query: WishlistQuery, identfier: AnyHashable?, previousResultBlock: (() -> WishlistResult?)?, resultBlock: ((WishlistResult, AnyHashable?) -> Void)?, completion: @escaping (WishlistResult?, Error?, AnyHashable?) -> Void) {
           shared?.fetchWishlist(query, identifier: identfier, previousResultBlock: previousResultBlock, resultBlock: resultBlock, completion: completion)
       }

    /**
     Makes a search in the API catalog given a `BookingItemSearchQuery`

     - Parameters:
     - searchQuery: The `BookingItemSearchQuery` with the search parameters
     - delegate: A `BookingItemSearchDelegate` that is notified if the search is successful
     */

    public static func searchBookingItems(searchQuery: BookingItemQuery, identifier: AnyHashable?, delegate: BookingItemSearchDelegate) {
        shared?.searchBookingItems(searchQuery, identifier: identifier, previousResultBlock: { [weak delegate]() -> BookingItemSearchResult? in
            delegate?.previousResult()
            }, resultBlock: { (result, identifier) in
                delegate.bookingSearchDidReceive(result, identifier: identifier)
        }, completion: { (result, error, identifier) in
            if let error = error {
                delegate.bookingItemSearchDidFailWith(error, identifier: identifier)
            } else {
                delegate.bookingItemSearchDidSucceedWith(result!, identifier: identifier)
            }
        })
    }

    /**
     Makes a search in the API catalog given a `BookingItemSearchQuery`

     - Parameters:
     - searchQuery: The `BookingItemSearchQuery` with the search parameters
     - identifier: An optional hash identifying the request. This value is returned back in the callbacks. Use this to distinguish between different requests
     - previousResultBlock: A block called (on a worker thread) to return any previous results that are to be merged
     - resultBlock: A block called (on a worker thread) with the final merged results
     - completion: A completion block that is called when the results are ready.
     */

    public static func searchBookingItems(searchQuery: BookingItemQuery, identifier: AnyHashable?, previousResultBlock: (() -> BookingItemSearchResult?)?, resultBlock: ((BookingItemSearchResult?, AnyHashable?) -> Void)?,  completion: @escaping (BookingItemSearchResult?, Error?, AnyHashable?)-> Void) {
        shared?.searchBookingItems(searchQuery, identifier: identifier, previousResultBlock: previousResultBlock, resultBlock: resultBlock, completion: completion)
    }

    /**
     Makes a search in the API catalog given a `ParkingItemSearchQuery`

     - Parameters:
     - searchQuery: The `ParkingItemSearchQuery` with the search parameters
     - delegate: A `ParkingItemSearchDelegate` that is notified if the search is successful
     */

    public static func searchParkingItems(searchQuery: ParkingItemQuery, identifier: AnyHashable?, delegate: ParkingItemSearchDelegate) {
        shared?.searchParkingItems(searchQuery, identifier: identifier, previousResultBlock: { [weak delegate]() -> ParkingItemSearchResult? in
            delegate?.previousResult()
            }, resultBlock: { (result, identifier) in
                delegate.parkingSearchDidReceive(result, identifier: identifier)
        }, completion: { (result, error, identifier) in
            if let error = error {
                delegate.parkingItemSearchDidFailWith(error, identifier: identifier)
            } else {
                delegate.parkingItemSearchDidSucceedWith(result!, identifier: identifier)
            }
        })
    }

    /**
     Makes a search in the API catalog given a `ParkingItemSearchQuery`

     - Parameters:
     - searchQuery: The `ParkingItemSearchQuery` with the search parameters
     - identifier: An optional hash identifying the request. This value is returned back in the callbacks. Use this to distinguish between different requests
     - previousResultBlock: A block called (on a worker thread) to return any previous results that are to be merged
     - resultBlock: A block called (on a worker thread) with the final merged results
     - completion: A completion block that is called when the results are ready.
     */

    public static func searchParkingItems(searchQuery: ParkingItemQuery, identifier: AnyHashable?, previousResultBlock: (() -> ParkingItemSearchResult?)?, resultBlock: ((ParkingItemSearchResult?, AnyHashable?) -> Void)?,  completion: @escaping (ParkingItemSearchResult?, Error?, AnyHashable?)-> Void) {
        shared?.searchParkingItems(searchQuery, identifier: identifier, previousResultBlock: previousResultBlock, resultBlock: resultBlock, completion: completion)
    }
}
