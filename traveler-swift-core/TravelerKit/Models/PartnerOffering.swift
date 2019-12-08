//
//  PartnerOffering.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-11-23.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// An offering for a `PartnerOfferingsItem`
public struct PartnerOffering: Decodable, ProductOffering {
    /// Id
    public let id: String
    /// Title
    public let name: String
    /// Description
    public let description: String?
    /// Icon
    public let iconURL: URL?
    /// Available quantities
    public let availableQuantity: Int
    /// Price
    public let price: Price


    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "name"
        case description = "description"
        case iconURL = "image"
        case availability = "availableQuantity"
        case price = "price"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String?.self, forKey: .description)
        self.iconURL = try container.decode(URL?.self, forKey: .iconURL)
        self.availableQuantity = try container.decode(Int.self, forKey: .availability)
        self.price = try container.decode(Price.self, forKey: .price)
    }

}
