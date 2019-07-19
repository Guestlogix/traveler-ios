
//
//  CatalogItemTests.swift
//  TravelerKitTests
//
//  Created by Omar Padierna on 2019-07-19.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import XCTest
@testable import TravelerKit

class CatalogItemTests: XCTestCase {
    func categoryTest() {
        //given
        let jsonData = "{\"id\":\"ite_hkVh9VhhvV11nk_\",\"title\":\"2H Kensington Market & Chinatown Tour in Toronto\",\"subTitle\":\"Tour\",\"thumbnail\":\"https://res.cloudinary.com/livngds/image/upload/h_120/v1/CENTRAL/products/12618/k8a04o1lypxmah4xzcw0.jpg\",\"priceStartingAt\":{\"value\":30.29,\"baseCurrency\":\"USD\",\"exchangeEnabled\":true,\"exchangeRates\":{\"aed\":3.672955,\"aud\":1.419814,\"cad\":1.306199,\"chf\":0.982648,\"dkk\":6.654389,\"eur\":0.891387,\"gbp\":0.800073,\"hkd\":7.80835,\"huf\":289.551794,\"jpy\":107.78633333,\"nok\":8.574748,\"pln\":3.78861,\"sek\":9.384461,\"sgd\":1.360278,\"usd\":1.0}},\"categories\":[\"Tour\"]}".data(using: .utf8)!

        let decoder = JSONDecoder()
        //when
        let catalogItem = try! decoder.decode(CatalogItem.self, from: jsonData)
        //then
        XCTAssert(catalogItem.categories[0].rawValue == "Tour")
    }
}
