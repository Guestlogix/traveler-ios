//
//  QueryType.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-10-04.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// The type of query in a `QueryItem`
public enum QueryType: String, Decodable {
    case parking = "Parking"
    case booking = "Booking"
}
