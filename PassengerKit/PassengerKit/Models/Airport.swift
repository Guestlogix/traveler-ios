//
//  Airport.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-10-17.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

/**
 Refer to Flight.swift for nested JSON structure
 **/

public struct Airport: Decodable {
    public let code: String
    public let name: String
    public let city: String

    enum CodingKeys: String, CodingKey {
        case code = "iata"
        case name = "name"
        case city = "city"
    }
}
