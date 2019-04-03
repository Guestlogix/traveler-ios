//
//  Airport.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-10-17.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

/// Represents information about an airport
public struct Airport: Decodable, Equatable {
    /// IATA code
    public let code: String
    /// Airport name
    public let name: String
    /// City
    public let city: String

    enum CodingKeys: String, CodingKey {
        case code = "iata"
        case name = "name"
        case city = "city"
    }
}
