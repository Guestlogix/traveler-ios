//
//  ItineraryItemType.swift
//  TravelerKit
//
//  Created by Rakin Hoque on 2019-11-21.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public enum ItineraryItemType: String, Decodable {
    case booking = "OrderBooking"
    case parking = "OrderParking"
    case transportation = "OrderTransportation"
    case flight = "Flight"
}
