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

    public static var sandboxMode: Bool {
        return shared?.sandboxMode ?? false
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

    func identify(_ identifier: String?, attributes: [String: Any?]?) {
        self.session.identity = identifier

        guard let attributes = attributes, let travelerProfileId = session.identity else {
            return
        }
        let requestOperation = AuthenticatedRemoteRequestOperation(path: .storeAttributes(attributes, travelerId: travelerProfileId), session: session)
        let blockOperation = BlockOperation { [unowned requestOperation] in
            if let error = requestOperation.error {
                Log("There's an error storing user attributes.", data: error, level: .error)
            }
        }
        blockOperation.addDependency(requestOperation)
        queue.addOperation(requestOperation)
        OperationQueue.main.addOperation(blockOperation)
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

    func fetchProductDetails(_ product: Product, completion: @escaping (CatalogItemDetails?, Error?) -> Void) {
        let fetchOperation: AuthenticatedRemoteFetchOperation<AnyItemDetails>
        let travelerProfileId = session.identity

        var path: AuthPath

        switch product.productType {
        case .booking:
            path = .bookingItem(product, travelerId: travelerProfileId)
        case .parking:
            path = .parkingItem(product, travelerId: travelerProfileId)
        case .partnerOffering:
            path = .partnerOfferingItem(product, travelerID: travelerProfileId)
        }

        fetchOperation = AuthenticatedRemoteFetchOperation<AnyItemDetails>(path: path, session: session)

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

    func fetchPasses(product: BookingItem, availability: Availability, option: BookingOption?, completion: @escaping ([Pass]?, Error?) -> Void) {
        let fetchOperation = AuthenticatedRemoteFetchOperation<[Pass]>(path: .passes(product, availability: availability, option: option), session: session)
        let blockOperation = BlockOperation { [unowned fetchOperation] in
            completion(fetchOperation.resource, fetchOperation.error)
        }

        blockOperation.addDependency(fetchOperation)

        queue.addOperation(fetchOperation)
        OperationQueue.main.addOperation(blockOperation)
    }

    //TODO: See if its possible to reconcile fetchPasses and fetchOfferings into a single method.
    func fetchPartnerOfferings(product: PartnerOfferingItem, completion: @escaping ([PartnerOfferingGroup]?, Error?) -> Void) {
        let fetchOperation = AuthenticatedRemoteFetchOperation<[PartnerOfferingGroup]>(path: .partnerOfferings(product), session: session)
        let blockOperation = BlockOperation { [unowned fetchOperation] in
            completion(fetchOperation.resource, fetchOperation.error)
        }

        blockOperation.addDependency(fetchOperation)

        queue.addOperation(fetchOperation)
        OperationQueue.main.addOperation(blockOperation)
    }

    /**TODO: Find a better way to handle the use of required/non-required passes/offerings/etc for different types of products. Aim for compiler help perhaps an enum with associated values?
     Ata's suggestion: Generics and associated types.
     **/
    func fetchPurchaseForm(product: Product, offerings: [ProductOffering], completion: @escaping (PurchaseForm?, Error?) -> Void) {
        let travelerProfileId = session.identity
        var path: AuthPath

        switch product.productType {
        case .booking:
            if offerings.count == 0 {
                Log("Options can't be empty for Booking Items", data: nil, level: .error)
                completion(nil, PurchaseFormFetchingError.noOptions)
                return
            } else if  ((offerings as? [Pass]) != nil) {
                path = .bookingQuestions(product, passes: offerings as! [Pass], travelerId: travelerProfileId)
            } else {
                Log("Options type mismatch. Expecting Pass type in array", data: nil, level: .error)
                completion(nil, PurchaseFormFetchingError.optionTypeMismatch)
                return
            }
        case .parking:
            path = .parkingQuestions(product, travelerId: travelerProfileId)
        case .partnerOffering:
            if ((offerings as? [PartnerOffering]) != nil)  {
                path = .partnerOfferingsQuestions(product, offerings: offerings as! [PartnerOffering], travelerId: travelerProfileId)
            } else {
                Log("Options type mismatch. Expecting PartnerOffering type in array", data: nil, level: .error)
                completion(nil, PurchaseFormFetchingError.optionTypeMismatch)
                return
            }
        }

        let fetchOperation = AuthenticatedRemoteFetchOperation<[QuestionGroup]>(path: path, session: session)
        let blockOperation = BlockOperation { [unowned fetchOperation] in
            if let groups = fetchOperation.resource {
                let purchaseForm = PurchaseForm(product: product, offerings: offerings, questionGroups: groups)
                completion(purchaseForm, nil)
            } else {
                completion(nil, fetchOperation.error)
            }
        }

        blockOperation.addDependency(fetchOperation)

        queue.addOperation(fetchOperation)
        OperationQueue.main.addOperation(blockOperation)
    }


    func createOrder(purchaseForm: PurchaseForm, completion: @escaping (Order?, Error?) -> Void) {
        let fetchOperation = AuthenticatedRemoteFetchOperation<Order>(path: .createOrder([purchaseForm], travelerId: session.identity), session: session)
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

    func cancelOrder(_ request: CancellationRequest, completion: @escaping (Order?, Error?) -> Void) {
        let validationResult = request.validate()
        switch validationResult {
        case .some(let error):
            completion(nil, error)
        case .none:
            let fetchOperation = AuthenticatedRemoteFetchOperation<Order>(path: .cancelOrder(request), session: session)
            let blockOperation = BlockOperation { [unowned fetchOperation] in
                completion(fetchOperation.resource, fetchOperation.error)
            }

            blockOperation.addDependency(fetchOperation)

            queue.addOperation(fetchOperation)
            OperationQueue.main.addOperation(blockOperation)
        }
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
    func removeFromWishlist(_ item: Product, result: WishlistResult?, completion: @escaping(Product, CatalogItemDetails?, WishlistResult?, Error?) -> Void) -> WishlistResult? {
        guard let travelerProfileId = session.identity else {
            completion(item, nil, result, WishlistToggleError.unidentifiedTraveler)
            return nil
        }

        var immediateResult: WishlistResult?

        if var result = result {
            result.remove(item)
            immediateResult = result
        }

        let fetchOperation = AuthenticatedRemoteFetchOperation<AnyItemDetails>(path: .wishlistRemove(item, travelerId: travelerProfileId), session: session)
        let blockOperation = BlockOperation { [unowned fetchOperation] in
            completion(item, fetchOperation.resource?.payload, result, fetchOperation.error)
        }

        blockOperation.addDependency(fetchOperation)
        queue.addOperation(fetchOperation)
        OperationQueue.main.addOperation(blockOperation)

        return immediateResult
    }

    func addToWishlist(_ item: Product, completion: @escaping(Product, CatalogItemDetails?, Error?) -> Void) {
        guard let travelerProfileId = session.identity else {
            completion(item, nil, WishlistToggleError.unidentifiedTraveler)
            return
        }


        let fetchOperation = AuthenticatedRemoteFetchOperation<AnyItemDetails>(path: .wishlistAdd(item, travelerId: travelerProfileId), session: session)
        let blockOperation = BlockOperation { [unowned fetchOperation] in
            completion(item, fetchOperation.resource?.payload, fetchOperation.error)
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

        let blockOperation = BlockOperation { [unowned fetchOperation] in
            if let result = wrapper.result {
                completion(result, nil, identifier)
            } else {
                completion(nil, fetchOperation.error!, identifier)
            }
        }

        let mergeOperation = BlockOperation { [unowned fetchOperation] in
            guard let result = fetchOperation.resource else { return }

            if let previousResultBlock = previousResultBlock, let previousResult = previousResultBlock() {
                if let mergedResult = previousResult.merge(result) {
                    wrapper.result = mergedResult
                    resultBlock?(wrapper.result!, identifier)
                } else {
                    completion(nil, WishlistResultError.resultMismatch, identifier)
                    blockOperation.cancel()
                }
            } else {
                wrapper.result = previousResultBlock?()?.merge(result) ?? result
                resultBlock?(wrapper.result!, identifier)
            }
        }

        mergeOperation.addDependency(fetchOperation)
        blockOperation.addDependency(mergeOperation)

        queue.addOperation(fetchOperation)
        serialQueue.addOperation(mergeOperation)
        OperationQueue.main.addOperation(blockOperation)
    }

    func searchBookingItems(_ searchQuery: BookingItemQuery, identifier: AnyHashable?, previousResultBlock: (() -> BookingItemSearchResult?)?, resultBlock: ((BookingItemSearchResult, AnyHashable?) -> Void)?, completion: @escaping (BookingItemSearchResult?, Error?, AnyHashable?) -> Void) {

        // TODO: Use a guard statement here

        if !searchQuery.isValid() {
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

        if !searchQuery.isValid() {
            completion(nil , SearchQueryError.invalidQuery, nil)
        } else {
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
    }

    func fetchSimilarProducts(to product: Product, completion: @escaping (Catalog?, Error?) -> Void) {
        let fetchOperation = AuthenticatedRemoteFetchOperation<Catalog>(path: .similarItems(product), session: session)
        let blockOperation = BlockOperation { [unowned fetchOperation] in
            completion(fetchOperation.resource, fetchOperation.error)
        }

        blockOperation.addDependency(fetchOperation)

        queue.addOperation(fetchOperation)
        OperationQueue.main.addOperation(blockOperation)
    }

    func fetchEphemeralStripeCustomerKey(forVersion apiVersion: String, completion: @escaping (EphemeralKey?, Error?) -> Void) {
        guard let travlerId = session.identity else {
            completion(nil, EphemeralKeyError.unidentifiedTraveler)
            return
        }

        let fetchOperation = AuthenticatedRemoteFetchOperation<EphemeralKey>(path: .stripeEphemeralKey(version: apiVersion, travlerId: travlerId), session: session)
        let blockOperation = BlockOperation { [unowned fetchOperation] in
            completion(fetchOperation.resource, fetchOperation.error)
        }

        blockOperation.addDependency(fetchOperation)

        queue.addOperation(fetchOperation)
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

    public static func identify(_ identifier: String?, attributes: [String: Any?]? = nil) {
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
     Fetches the `CatalogItemDetails` for a given `Product`.

     - Parameters:
        - product: A `Product` for which to fetch the details.
        - delegate: A `CatalogItemDetailsFetchDelegate` that is notified of the results.
     */

    public static func fetchProductDetails(_ product: Product, delegate: CatalogItemDetailsFetchDelegate) {
        shared?.fetchProductDetails(product, completion: { [weak delegate] (details, error) in
            if let details = details {
                delegate?.catalogItemDetailsFetchDidSucceedWith(details)
            } else {
                delegate?.catalogItemDetailsFetchDidFailWith(error!)
            }
        })
    }

    /**
     Fetches the `CatalogItemDetails` for a given `Product`.

     - Parameters:
        - product: A `Product` for which to fetch the details.
        - delegate: A completion block that is called when the results are ready.
     */

    public static func fetchProductDetails(_ catalogItem: Product, completion: @escaping (CatalogItemDetails?, Error?) -> Void) {
        shared?.fetchProductDetails(catalogItem, completion: completion)
    }

    /**
     Fetches the `Pass`es associated with a given `Product` for a given `Availability` and `BookingOption`.

     - Parameters:
        - product: The `Product` for which to fetch the passes for.
        - availability: The `Availability` for that Product to fetch the passes for.
        - option: An optional `BookingOption` to fetch passes for.
        - completion: A completion block that is called when the results are ready.
     */

    public static func fetchPasses(product: BookingItem, availability: Availability, option: BookingOption?, completion: @escaping ([Pass]?, Error?) -> Void) {
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

    public static func fetchPasses(product: BookingItem, availability: Availability, option: BookingOption?, delegate: PassFetchDelegate) {
        shared?.fetchPasses(product: product, availability: availability, option: option, completion: { [weak delegate] (passes, error) in
            if let passes = passes {
                delegate?.passFetchDidSucceedWith(passes)
            } else {
                delegate?.passFetchDidFailWith(error!)
            }
        })
    }

    //TODO: See if its possible to reconcile fetchPasses and fetchPartnerOfferings into a single method
    /**
     Fetches the `PartnerOffering`s associated with a given `PartnerOfferingItem`
     - Parameters:
        - product: The `PartnerOfferingItem` for which to fetch the passes for.
        - delegate: A `FetchOfferingsDelegate` that is notified of the results
     */

    public static func fetchPartnerOfferings(product: PartnerOfferingItem, delegate: FetchPartnerOfferingsDelegate) {
        shared?.fetchPartnerOfferings(product: product, completion: { [weak delegate] (offerings, error) in
            if let offerings = offerings {
                delegate?.fetchOfferingsDidSucceedWith(offerings)
            } else {
                delegate?.fetchOfferingsDidFailWith(error!)
            }
        })
    }

    /**
    Fetches the `PartnerOffering`s associated with a given `PartnerOfferingsItem`
    - Parameters:
       - product: The `PartnerOfferingItem` for which to fetch the passes for.
       - completion: A  completion block that is called when results are ready
    */

    public static func fetchPartnerOfferings(product: PartnerOfferingItem, completion: @escaping ([PartnerOfferingGroup]?, Error?) -> Void) {
        shared?.fetchPartnerOfferings(product: product, completion: completion)
    }

    /**
     Creates an `Order` for the supplied `PurchaseForm`.

     - Parameters:
        - purchaseForm: A `PurchaseForm` for which to create the `Order` for.
        - delgate: An `OrderCreateDelegate` that is notified of the results.
     */

    public static func createOrder(purchaseForm: PurchaseForm, delegate: OrderCreateDelegate) {
        shared?.createOrder(purchaseForm: purchaseForm, completion: { [weak delegate] (order, error) in
            if let order = order {
                delegate?.orderCreationDidSucceed(order)
            } else {
                delegate?.orderCreationDidFail(error!)
            }
        })
    }

    /**
     Creates an `Order` for the supplied `PurchaseForm`.

     - Parameters:
        - purchaseForm: A `PurchaseForm` for which to create the `Order` for.
        - completion: A completion block that is called when the results are ready.
     */

    public static func createOrder(purchaseForm: PurchaseForm, completion: @escaping (Order?, Error?) -> Void) {
        shared?.createOrder(purchaseForm: purchaseForm, completion: completion)
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
     Fetches the `PurchaseForm` for a given `Product` and array of `Pass`es.

     - Parameters:
        - product: A `Product` for which to fetch the `PurchaseForm`.
        - passes: An `Array<Pass>` for which to fetch the `PurchaseForm`.
        - completion: A completion block that is called when the results are ready.
     */

    public static func fetchPurchaseForm(product: Product, options: [ProductOffering] = [], completion: @escaping (PurchaseForm?, Error?) -> Void) {
        shared?.fetchPurchaseForm(product: product, offerings: options, completion: completion)
    }

    /**
     Fetches the `PurchaseForm` for a given `Product` and array of `Pass`es.

     - Parameters:
        - product: A `Product` for which to fetch the `PurchaseForm`.
        - passes: An `Array<Pass>` for which to fetch the `PurchaseForm`.
        - delegate: A `PurchaseFormFetchDelegate` that is notified of the results.
     */

    public static func fetchPurchaseForm(product: Product, options: [ProductOffering] = [], delegate: PurchaseFormFetchDelegate) {
        shared?.fetchPurchaseForm(product: product, offerings: options, completion: { [weak delegate] (form, error) in
            if let error = error {
                delegate?.purchaseFormFetchDidFailWith(error)
            } else {
                delegate?.purchaseFormFetchDidSucceedWith(form!)
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

    public static func cancelOrder(_ request: CancellationRequest, delegate: CancellationDelegate) {
        shared?.cancelOrder(request, completion: { [weak delegate] (order, error) in
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

    public static func cancelOrder(_ request: CancellationRequest, completion: @escaping (Order?, Error?) -> Void) {
        shared?.cancelOrder(request, completion: completion)
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
     Adds the given `CatalogItem` into the traveler's wishlist

     - Parameters:
     - item: The `Product` that needs to be wishlisted
     - delegate:  A `WishlistAddDelegate` that is notified if the items were wishlisted successfuly
     */

    public static func addToWishlist(_ item: Product, delegate: WishlistAddDelegate) {
        shared?.addToWishlist(item, completion: { [weak delegate] item, details, error in
            if let error = error {
                delegate?.wishlistAddDidFailWith(error)
            } else {
                delegate?.wishlistAddDidSucceedFor(item, with: details!)
            }
        })
    }

    /**
     Adds the given `Product` into the traveler's wishlist

     - Parameters:
     - item: The `Product` thats need to be wishlisted
     - completion:  A completion block that is called when the items are wishlisted
     */

    public static func addToWishlist(_ item: Product, completion: @escaping (Product, CatalogItemDetails?, Error?) -> Void) {
        shared?.addToWishlist(item, completion: completion)
    }

    /**
     Removes the given `Product` from the traveler's wishlist

     - Parameters:
     - item: The `Product` that needs to be removed from the wishlist
     - delegate:  A `WishlistRemoveDelegate` that is notified if the item is removed from the wishlist successfuly
     */
    @discardableResult
    public static func removeFromWishlist(_ item: Product, result: WishlistResult?, delegate: WishlistRemoveDelegate) -> WishlistResult? {
        return shared?.removeFromWishlist(item, result: result, completion: { [weak delegate] (item, details, result, error) in
            if let error = error {
                delegate?.wishlistRemoveDidFailWith(error, result: result)
            } else {
                delegate?.wishlistRemoveDidSucceedFor(item, with: details)
            }
        })
    }

    /**
     Removes the given `Product` from the traveler's wishlist

     - Parameters:
     - item: The `Product` that needs to be removed from the wishlist
     - completion: A completion block that is called when the item is removed from the wishlist
     */

    @discardableResult
    public static func removeFromWishlist(_ item: Product, result: WishlistResult?, completion: @escaping (Product, CatalogItemDetails?, WishlistResult?, Error?) -> Void) -> WishlistResult? {
        return shared?.removeFromWishlist(item, result: result, completion: completion)
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

    public static func searchBookingItems(_ searchQuery: BookingItemQuery, identifier: AnyHashable?, delegate: BookingItemSearchDelegate) {
        shared?.searchBookingItems(searchQuery, identifier: identifier, previousResultBlock: { [weak delegate] () -> BookingItemSearchResult? in
            delegate?.previousResult()
            }, resultBlock: { [weak delegate] (result, identifier) in
                delegate?.bookingItemSearchDidReceive(result, identifier: identifier)
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

    public static func searchBookingItems(_ searchQuery: BookingItemQuery, identifier: AnyHashable?, previousResultBlock: (() -> BookingItemSearchResult?)?, resultBlock: ((BookingItemSearchResult?, AnyHashable?) -> Void)?,  completion: @escaping (BookingItemSearchResult?, Error?, AnyHashable?)-> Void) {
        shared?.searchBookingItems(searchQuery, identifier: identifier, previousResultBlock: previousResultBlock, resultBlock: resultBlock, completion: completion)
    }

    /**
     Makes a search in the API catalog given a `ParkingItemSearchQuery`

     - Parameters:
     - searchQuery: The `ParkingItemSearchQuery` with the search parameters
     - delegate: A `ParkingItemSearchDelegate` that is notified if the search is successful
     */

    public static func searchParkingItems(_ searchQuery: ParkingItemQuery, identifier: AnyHashable?, delegate: ParkingItemSearchDelegate) {
        shared?.searchParkingItems(searchQuery, identifier: identifier, previousResultBlock: { [weak delegate] () -> ParkingItemSearchResult? in
            delegate?.previousResult()
            }, resultBlock: { [weak delegate] (result, identifier) in
                delegate?.parkingItemSearchDidReceive(result, identifier: identifier)
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

    public static func searchParkingItems(_ searchQuery: ParkingItemQuery, identifier: AnyHashable?, previousResultBlock: (() -> ParkingItemSearchResult?)?, resultBlock: ((ParkingItemSearchResult?, AnyHashable?) -> Void)?,  completion: @escaping (ParkingItemSearchResult?, Error?, AnyHashable?)-> Void) {
        shared?.searchParkingItems(searchQuery, identifier: identifier, previousResultBlock: previousResultBlock, resultBlock: resultBlock, completion: completion)
    }

    /**
    Returns a `Catalog` containing similar items given a `Product`
     - Parameters:
     - to: The reference `Product`
     - delegate: A `SimilarProductsFetchDelegate` that is notified if the fetch is successful
     */

    public static func fetchSimilarProducts(to product: Product, delegate: SimilarProductsFetchDelegate) {
        shared?.fetchSimilarProducts(to: product, completion: { [weak delegate] (result, error) in
            if let result = result {
                delegate?.similarItemsFetchDidSucceedWith(result)
            } else {
                delegate?.similarItemsFetchDidFailWith(error!)
            }
        })
    }

    /**
     Returns a `Catalog` contaning similar items given a `Product`
     - Parameters:
     - to: The reference `Product`
     - completion: A completion block that is called when the results are ready
     */

    public static func fetchSimilarProducts(to product: Product, completion: @escaping (Catalog?, Error?) -> Void) {
        shared?.fetchSimilarProducts(to: product, completion: completion)
    }

    /**
     Returns a traveler authenticated `URLRequest` that fetches the ephemeral Stripe Customer key
     - Parameters:
     - apiVersion: The API Version of the Stripe SDK you need to fetch the key for
     - completion: A completion block that is called when the results are ready
     */

    public static func fetchEphemeralStripeCustomerKey(forVersion apiVersion: String, completion: @escaping (EphemeralKey?, Error?) -> Void) {
        shared?.fetchEphemeralStripeCustomerKey(forVersion: apiVersion, completion: completion)
    }

    /**
    Returns a traveler authenticated `URLRequest` that fetches the ephemeral Stripe Customer key
    - Parameters:
    - apiVersion: The API Version of the Stripe SDK you need to fetch the key for
    - delegate: A `EphemeralKeyFetchDelegate` that is notified if the fetch is successful
     */

    public static func fetchEphemeralStripeCustomerKey(forVersion apiVersion: String, delegate: EphemeralKeyFetchDelegate) {
        shared?.fetchEphemeralStripeCustomerKey(forVersion: apiVersion, completion: { [weak delegate] (json, error) in
            if let json = json {
                delegate?.ephemeralKeyFetchDidSucceedWith(json)
            } else {
                delegate?.ephemeralKeyFetchDidFailWith(error!)
            }
        })
    }
}
