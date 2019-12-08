//
//  ProductOfferingGroup.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-11-23.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation
/// A group that contains `PartnerOffering`s
public struct PartnerOfferingGroup: Decodable {
    /// Title
    public let title: String
    /// Subtitle
    public let subtitle: String
    /// Options
    public let offerings: [PartnerOffering]
    /// Starting price
    public let startingPrice: Price

    enum CodingKeys: String, CodingKey {
        case title = "title"
        case subtitle = "subTitle"
        case items = "items"
        case startingPrice = "priceStartingAt"
    }

     public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.title = try container.decode(String.self, forKey: .title)
        self.subtitle = try container.decode(String.self, forKey: .subtitle)
        self.offerings = try container.decode([PartnerOffering].self, forKey: .items)
        self.startingPrice = try container.decode(Price.self, forKey: .startingPrice)
    }
}
