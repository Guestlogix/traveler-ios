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
        case purchaseStrategy = "purchaseStrategy"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.type = try container.decode(ProductType.self, forKey: .purchaseStrategy)

        switch type {
        case .booking:
            let bookingItem = try BookingItem(from: decoder)
            self.bookingItem = bookingItem
            self.parkingItem = nil
        case .parking:
            let parkingItem = try ParkingItem(from: decoder)
            self.parkingItem = parkingItem
            self.bookingItem = nil
        }
    }
}
