//
//  AnyItem.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-10-08.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// An item of any kind
struct AnyItem: Decodable {
    let bookingItem: BookingItem?
    let parkingItem: ParkingItem?
    let type: ProductType

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case subTitle = "subTitle"
        case thumbnail = "thumbnail"
        case price = "priceStartingAt"
        case categories = "categories"
        case type = "purchaseStrategy"
        case location = "geoLocation"
        case providerTranslationAttribution = "providerTranslationAttribution"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.type = try container.decode(ProductType.self, forKey: .type)

        let id = try container.decode(String.self, forKey: .id)
        let title = try container.decode(String.self, forKey: .title)
        let subTitle = try container.decode(String.self, forKey: .subTitle)
        let imageURL = try container.decode(URL.self, forKey: .thumbnail)
        let price = try container.decode(Price.self, forKey: .price)
        let categories = try container.decode([ProductItemCategory].self, forKey: .categories)
        let productType = try container.decode(ProductType.self, forKey: .type)
        let location = try container.decode(Coordinate.self, forKey: .location)
        let providerTranslationAttribution = try container.decode(ProviderTranslationAttribution.self, forKey: .providerTranslationAttribution)

        switch type {
        case .booking:
            self.parkingItem = nil
            self.bookingItem = BookingItem(id: id, price: price, productType: productType, categories: categories, title: title, subTitle: subTitle, imageURL: imageURL, providerTranslationAttribution: providerTranslationAttribution, location: location, isAvailable: true)
        case .parking:
            self.parkingItem = ParkingItem(id: id, price: price, productType: productType, categories: categories, title: title, subTitle: subTitle, imageURL: imageURL, providerTranslationAttribution: providerTranslationAttribution, location: location)
            self.bookingItem = nil
        }
    }
}
