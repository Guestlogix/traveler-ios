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
    let partnerOfferingsItem: PartnerOfferingItem?
    let type: ProductType

    enum CodingKeys: String, CodingKey {
        case type = "purchaseStrategy"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.type = try container.decode(ProductType.self, forKey: .type)

        switch type {
        case .booking:
            self.parkingItem = nil
            self.bookingItem = try BookingItem(from: decoder)
            self.partnerOfferingsItem = nil
        case .parking:
            self.parkingItem = try ParkingItem(from: decoder)
            self.bookingItem = nil
            self.partnerOfferingsItem = nil
        case .partnerOfferings:
            self.parkingItem = nil
            self.bookingItem = nil
            self.partnerOfferingsItem = try PartnerOfferingItem(from: decoder)
        }
    }
}
