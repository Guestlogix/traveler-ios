//
//  SearchQuery.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-10-05.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation
/// An enum that encompasses all possible search queries
public enum SearchQuery {
    case booking(query: BookingQuery)
    case parking(query: ParkingQuery)
}
