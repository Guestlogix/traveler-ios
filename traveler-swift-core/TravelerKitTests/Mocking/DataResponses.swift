//
//  DataResponses.swift
//  TravelerKitTests
//
//  Created by Omar Padierna on 2019-10-28.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

struct DataResponses {
    struct Normalized {
        static let location: MockJSON = [
            "latitude": 13.45443433,
            "longitude": 14.2323323
        ]
        
        static let price: MockJSON = [
            "value": 42.00,
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
        
        static let translationProvider: MockJSON = [
            "image": nil,
        ]
        
        static let item: MockJSON = [
            "id": "12345",
            "title": "Normalized item",
            "subTitle": "Normalized item subtitle",
            "thumbnail": "https://www.normalized.com/normalized.png",
            "priceStartingAt": Normalized.price,
            "isAvailable": true,
            "purchaseStrategy": "Bookable",
            "geoLocation": Normalized.location,
            "providerTranslationAttribution": Normalized.translationProvider,
            "categories": ["Tour"]
        ]
    }

    //MARK:- Catalog
    static func catalogData() -> Data {
        let searchParams: MockJSON = [
            "text": nil,
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
            "polling": false
        ]

        let queryItem: MockJSON = [
            "type": "Parking",
            "title": "Parking in Toronto",
            "subTitle": nil,
            "thumbnail": "http://traveler-api-v1-dev.dev.svc.cluster.local/parking_image.jpg",
            "searchParams": searchParams
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

        guard let data = groupsJSON.jsonString()?.data(using: .utf8) else {
            fatalError("Bad JSON for Catalog")
        }

        return data
    }

    //MARK:- Supplier (No Trademark)
    static func supplierDataNoTradeMark() -> Data {
        //given
        let incompleteTrademarkJSON: MockJSON = [
            "id": "SupplierID",
            "name": "Tiqets",
            "trademark": nil
        ]

        guard let data = incompleteTrademarkJSON.jsonString()?.data(using: .utf8) else {
            fatalError("Bad JSON for Supplier")
        }

        return data
    }

    //MARK:- Supplier
    static func supplierData() -> Data {
        let trademarkJSON: MockJSON = [
            "iconUrl": "https://myicon.com",
            "copyRight":"Simple ricks"
        ]

        let supplierJSON: MockJSON = [
            "id": "SuppliedID",
            "name": "Tiqets",
            "trademark": trademarkJSON
        ]

        guard let data = supplierJSON.jsonString()?.data(using: .utf8) else {
            fatalError("Bad JSON for Supplier")
        }
        return data
    }
    
    //MARK:- Trademark (Bad URL)
    static func trademarkWithBadUrl() -> Data {
        let tradeMarkJSON: MockJSON = [
            "iconUrl": "www.creedthoughts.gov.www'\'creedthoughts",
            "copyRight": "Sometimes when I,m sick, or feeling blue, I drink vinegar. I like all kinds: balsamic, vodka, orange juice, leaves."
        ]

        guard let data = tradeMarkJSON.jsonString()?.data(using: .utf8) else {
            fatalError("Bad JSON for trademark")
        }

        return data
    }

    //MARK:- BookingItemDetails
    static func bookingItemDetailsData() -> Data {
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
            "priceStartingAt": Normalized.price,
            "categories": ["Activity"],
            "isAvailable": true,
            "purchaseStrategy": "Bookable",
            "geoLocation": nil,
            "providerTranslationAttribution": translationProvider
        ]

        guard let data = bookingItemDetailsJSON.jsonString()?.data(using: .utf8) else {
            fatalError("Bad JSON for BookingItemDetails")
        }

        return data
    }

    //MARK:- Authentication Data
    static func authData() -> Data {
        let authJSON: MockJSON = [
            "token": "A token",
            "created": "2019-10-25T18:49:57.103Z",
            "expires": "2019-10-25T18:49:57.104Z"
        ]

        guard let data = authJSON.jsonString()?.data(using: .utf8) else {
            fatalError("Invalid JSON data for authentication")
        }

        return data
    }

    //MARK:- BookingItem
    static func bookingItemData() -> Data {
        guard let data = Normalized.item.jsonString()?.data(using: .utf8) else {
            fatalError("Invalid JSON Data for Booking Item")
        }
        return data
    }

    //MARK:- Flights
    static func flightData() -> Data {
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

        let codeSharesItem: MockJSON = [
            "carrierCode": "AV",
            "number": 6926
        ]

        let codeShares: MockJSON = [
            codeSharesItem
        ]

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

        guard let data = flightJSON.jsonString()?.data(using: .utf8) else {
            fatalError("Bad JSON for Flights")
        }

        return data
    }
}
