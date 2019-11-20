//
//  AnyItem.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-10-08.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

// TODO: Rename to AnyPurchasableProduct
/// An item of any kind
struct AnyItem: Decodable {
    let bookingItem: BookingItem?
    let parkingItem: ParkingItem?
    let partnerOfferingItem: PartnerOfferingItem?
    let type: PurchaseType

    enum CodingKeys: String, CodingKey {
        case type = "purchaseStrategy"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.type = try container.decode(PurchaseType.self, forKey: .type)

        switch type {
        case .booking:
            self.parkingItem = nil
            self.bookingItem = try BookingItem(from: decoder)
            self.partnerOfferingItem = nil
        case .parking:
            self.parkingItem = try ParkingItem(from: decoder)
            self.bookingItem = nil
            self.partnerOfferingItem = nil
        case .partnerOffering:
            self.parkingItem = nil
            self.bookingItem = nil
            self.partnerOfferingItem = try PartnerOfferingItem(from: decoder)
        }
    }
}
