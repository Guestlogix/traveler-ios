//
//  DataResponses.swift
//  TravelerKitTests
//
//  Created by Omar Padierna on 2019-10-28.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

struct MockResponses {
    struct Normalized {
        static let location: MockJSON = [
            "latitude": 13.45443433,
            "longitude": 14.2323323
        ]
        
        static let translationProvider: MockJSON = [
            "image": nil,
        ]
        
        static let item: MockJSON = [
            "id": "12345",
            "title": "Normalized item",
            "subTitle": "Normalized item subtitle",
            "thumbnail": "https://www.normalized.com/normalized.png",
            "priceStartingAt": price(),
            "isAvailable": true,
            "purchaseStrategy": "Bookable",
            "geoLocation": Normalized.location,
            "providerTranslationAttribution": Normalized.translationProvider,
            "categories": ["Tour"]
        ]
        
        static let customer: MockJSON = [
            "title": "mr",
            "firstName": "test",
            "lastName": "test",
            "email": "test@test.com",
            "phone": "64712345671"
        ]
        
        static let searchParams: MockJSON = [
            "text": "test",
            "latitude": nil,
            "longitude": nil,
            "radius": nil,
            "topLeftLatitude": 43.73830947875977,
            "topLeftLongitude": -79.52555236816406,
            "bottomRightLatitude": 43.538309478759764,
            "bottomRightLongitude": -79.32555236816407,
            "categories": nil,
            "minPrice": nil,
            "maxPrice": nil,
            "currency": nil,
            "airport": nil,
            "startTime": "2019-10-29T07:37:50",
            "endTime": "2019-11-05T07:37:50",
            "polling": false,
            "sortField": "Price",
            "sortOrder": "Asc",
            "travelerId": nil
        ]
    }
    
    static func price(value: Double = 42.0) -> MockJSON {
        return [
            "value": MockJSON.double(value),
            "baseCurrency": "USD",
            "exchangeEnabled": true,
            "exchangeRates": [
                "aed": 3.673,
                "aud": 1.460526,
                "cad": 1.307933,
                "eur": 0.899169,
                "gbp": 0.776254,
                "usd": 1.0
            ]
        ]
    }
    
    //MARK:- Pagincation
    static func pagination(total: Int = 1) -> [String: MockJSON] {
        return [
            "skip": 0,
            "take": 0,
            "from": "2019-11-22T21:19:56+00:00",
            "to": "2019-11-22T21:19:56+00:00",
            "total": MockJSON.int(total)
        ]
    }

    //MARK:- Catalog
    static func catalog() -> MockJSON {
        let queryItem: MockJSON = [
            "type": "Parking",
            "title": "Parking in Toronto",
            "subTitle": nil,
            "thumbnail": "http://traveler-api-v1-dev.dev.svc.cluster.local/parking_image.jpg",
            "searchParams": Normalized.searchParams
        ]

        let queryItemsArray: MockJSON = [
            queryItem
        ]

        let groupQuery: MockJSON = [
            "type": "Query",
            "title": "Parking",
            "subTitle": nil,
            "description": nil,
            "featured": true,
            "items": queryItemsArray
        ]
        
        let groupItems: MockJSON = [
            "type": "Item",
            "title": "Top Rated by travellers",
            "subTitle": nil,
            "description": "Top Rated by travellers",
            "featured": false,
            "items": [Normalized.item]
        ]

        let groupsJSON: MockJSON = [
            "groups": [groupQuery, groupItems]
        ]

        return groupsJSON
    }

    //MARK:- Supplier (No Trademark)
    static func supplierNoTradeMark() -> MockJSON {
        //given
        let incompleteTrademarkJSON: MockJSON = [
            "id": "SupplierID",
            "name": "Tiqets",
            "trademark": nil
        ]

        return incompleteTrademarkJSON
    }

    //MARK:- Supplier
    static func supplier() -> MockJSON {
        let trademarkJSON: MockJSON = [
            "iconUrl": "https://myicon.com",
            "copyRight":"Simple ricks"
        ]

        let supplierJSON: MockJSON = [
            "id": "SuppliedID",
            "name": "Tiqets",
            "trademark": trademarkJSON
        ]

        return supplierJSON
    }
    
    //MARK:- Trademark (Bad URL)
    static func trademarkWithBadUrl() -> MockJSON {
        let tradeMarkJSON: MockJSON = [
            "iconUrl": "www.creedthoughts.gov.www'\'creedthoughts",
            "copyRight": "Sometimes when I,m sick, or feeling blue, I drink vinegar. I like all kinds: balsamic, vodka, orange juice, leaves."
        ]

        return tradeMarkJSON
    }
    
    //MARK:- Booking Schedule
    static func bookingSchedule() -> MockJSON {
        let bookingSchedule: MockJSON = [[
            "id": "string",
            "date": "2019-12-02",
            "optionSet": [
              "optionSetLabel": "Times",
              "options": [[
                  "id": "string",
                  "optionLabel": "string",
                  "disclaimer": "string"
              ]]
            ],
            "disclaimer": "string"
        ]]
        
        return bookingSchedule
    }
    
    //MARK:- Booking Pass
    static func bookingPass() -> MockJSON {
        let bookingPass: MockJSON = [[
            "id": "string",
            "title": "string",
            "description": "string",
            "price": price(),
            "maximumQuantity": 5,
            "minimumQuantity": 0
        ]]
        
        return bookingPass
    }
    
    //MARK:- Booking Question
    static func bookingQuestion() -> MockJSON {
        let bookingQuestion: MockJSON = [[
            "title": "string",
            "subTitle": "string",
            "questions": [[
                "id": "string",
                "title": "string",
                "description": "string",
                "required": true,
                "type": "Quantity",
                "maximumQuantity": 0,
                "choices": [[
                    "id": "string",
                    "label": "string",
                    "price": price()
                ]],
                "suggestedAnswer": nil,
                "suggestedAnswerFieldMapName": nil
            ]]
        ]]
        
        return bookingQuestion
    }

    //MARK:- BookingItemDetails
    static func bookingItemDetails() -> MockJSON {
        let attribute1: MockJSON = [
            "label": "Excludes",
            "value": "Special exhibitions"
        ]

        let attribute2: MockJSON = [
            "label": "Pre purchase",
            "value": "Free entry for kids 0-3, 1 Meeseks per visitor, and Indigenous Peoples. Free entry on Tuesdays or when Ruben is sleeping"
        ]

        let contactInfo: MockJSON = [
            "name": "Dr. Xenon Bloom",
            "email": "xenon@bloom.com",
            "website": "https://www.anatomyPark.com/contact",
            "phones": nil
        ]

        let trademark: MockJSON = [
            "iconUrl": "http:www.richSanchez.com/rick.jpg",
            "copyRight": "Wubba lubba dub dub"
        ]

        let supplier: MockJSON = [
            "name": "Rick Sanchez",
            "trademark": trademark
        ]

        let translationProvider: MockJSON = [
            "image": nil,
        ]

        let location: MockJSON = [
            "address": "Ruben's body",
            "latitude": -5.243,
            "longitude": 47.394
        ]

        let bookingItemDetailsJSON: MockJSON = [
            "description": "Spend a fun afternoon at The Anatomy Park!, be amazed by the effects of Tuberculosis in The Alveoli Forest, behold the Appendix Memorial, and enjoy a nice ride in the Cerbral Cortex Carousel",
            "imageUrls": ["https://rickandmorty.fandom.com/wiki/Anatomy_Park_(location)?file=S1e3_alveoli_forest.png","https://rickandmorty.fandom.com/wiki/Anatomy_Park_(location)?file=DiaphragmBounceHouse.png","https://rickandmorty.fandom.com/wiki/Anatomy_Park_(location)?file=S1e3_bladder_falls.png"],
            "information": [attribute1, attribute2],
            "contact": contactInfo,
            "locations": [location],
            "supplier": supplier,
            "termsAndConditions": nil,
            "isWishlisted": false,
            "disclaimer": nil,
            "id": "ite_abc123",
            "title": "The Anatomy Park",
            "subTitle": "A thrilling ride inside a homeless man named Ruben",
            "thumbnail": "www.anatomyPark.com/RubensColon.jpg",
            "priceStartingAt": price(),
            "categories": ["Activity"],
            "isAvailable": true,
            "purchaseStrategy": "Bookable",
            "geoLocation": nil,
            "providerTranslationAttribution": translationProvider
        ]

        return bookingItemDetailsJSON
    }

    //MARK:- Authentication Data
    static func auth() -> MockJSON {
        let authJSON: MockJSON = [
            "token": "A token",
            "created": "2019-10-25T18:49:57.103Z",
            "expires": "2020-10-25T18:49:57.104Z"
        ]

        return authJSON
    }

    //MARK:- BookingItem
    static func bookingItem() -> MockJSON {
        return Normalized.item
    }

    //MARK:- Flights
    static func flight() -> MockJSON {
        let origin: MockJSON = [
            "iata": "MEX",
            "name": "Benito Juarez International Airport",
            "street1": nil,
            "street2": nil,
            "city": "Mexico City",
            "cityCode": "MEX",
            "stateCode": nil,
            "postalCode": nil,
            "countryCode": "MX",
            "countryName": "Mexico",
            "latitude": 19.435278,
            "longitude": -99.072778,
            "utcOffsetHours": -6
        ]

        let destination: MockJSON = [
            "iata": "YYZ",
            "name": "Pearson International Airport",
            "street1": "",
            "street2": "",
            "city": "Toronto",
            "cityCode": "YTO",
            "stateCode": "ON",
            "postalCode": "L5P 1B2",
            "countryCode": "CA",
            "countryName": "Canada",
            "latitude": 43.681585,
            "longitude": -79.61146,
            "utcOffsetHours": -4
        ]

        let codeShares: MockJSON = [[
            "carrierCode": "AV",
            "number": 6926
        ]]

        let flightItem: MockJSON = [
            "id": "fli_aT91n94IYFh919FFZ_",
            "flightNumber": "AC1981",
            "origin": origin,
            "destination": destination,
            "stops": 0,
            "departureTerminal": "1",
            "arrivalTerminal": "1",
            "departureTime": "2019-12-27T13:20:00",
            "arrivalTime": "2019-12-27T18:45:00",
            "isCodeShare": false,
            "codeShares": codeShares
        ]

        let flightJSON: MockJSON = [
            flightItem
        ]

        return flightJSON
    }
    
    //MARK:- Orders
    static func orders() -> MockJSON {
        var orders: [String: MockJSON] = pagination()
        orders["result"] = [order()]
        
        return MockJSON.object(orders)
    }
    
    //MARK:- Order
    static func order() -> MockJSON {
        let order: MockJSON = [
            "id": "String",
            "referenceNumber": "String",
            "createdOn": "2019-11-21T19:27:25",
            "status": "Confirmed",
            "amount": price(),
            "products": [bookingProduct()],
            "customer": Normalized.customer,
            "creditCardType": "visa",
            "last4Digits": "****",
            "disclaimer": nil,
            "polling": false,
            "travelerId": "String"
        ]
        
        return order
    }
    
    //MARK:- Booking Product
    static func bookingProduct() -> MockJSON {
        let product: MockJSON = [
            "id": "booking",
            "price": price(),
            "title": "Skip the Line: Ripley's Aquarium of Canada in Toronto",
            "cancellationPolicy": "Non-refundable",
            "supplier": "Viator",
            "productStatus": "Available",
            "experienceDate": "2019-11-27T00:00:00",
            "purchaseStrategy": "Bookable",
            "passes": [[
                "id": "pas_hZFh9199FZhhFzMhhZWI2aSRC9_",
                "title": "Adult",
                "description": "Adult (14-64)",
                "price": price()
            ]],
            "information": [[
                "label": "Start Time",
                "value": ""
            ], [
                "label": "Duration",
                "value": "1 to 2 hours"
            ]],
            "categories": ["Activity", "Tour"]
        ]
        
        return product
    }
    
    //MARK:- Search
    static func search() -> MockJSON {
        var search: [String: MockJSON] = pagination()
        search["aggregation"] = [
            "price": [
                "max": price(),
                "min": price()
            ],
            "cities": [],
            "categories": [[
                "label": "Tour",
                "count": 1
            ], [
                "label": "Activity",
                "count": 1
            ], [
                "label": "Show",
                "count": 1
            ]]
        ]
        search["items"] = [bookingItem()]
        search["parameters"] = Normalized.searchParams
        
        return MockJSON.object(search)
    }
    
    //MARK:- Wishlist
    static func wishlist() -> MockJSON {
        var wishlist: [String: MockJSON] = pagination()
        wishlist["result"] = [bookingItem()]
        
        return MockJSON.object(wishlist)
    }
    
    //MARK:- Cancellation
    static func cancellation() -> MockJSON {
        let cancellation: MockJSON = [
            "id": "string",
            "totalRefund": price(),
            "cancellationCharge": price(value: 2),
            "orderAmount": price(value: 40),
            "quoteExpiresOn": "2019-12-02T19:39:19",
            "cancellationReason": "string",
            "products": [[
                "title": "string",
                "totalRefund": price(value: 42),
                "cancellationCharge": price(value: 2),
                "createdOn": "2019-12-02T19:39:19"
            ]],
            "cancellationReasons": [[
                "id": "MyTripWasDelayedOrCancelled",
                "value": "string",
                "explanationRequired": true
            ]]
        ]
        
        return cancellation
    }
}
