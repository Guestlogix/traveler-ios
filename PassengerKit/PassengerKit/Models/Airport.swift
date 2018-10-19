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
        case code = "iataCode"
        case name = "name"
        case city = "city"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let city = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .city)

        self.code = try container.decode(String.self, forKey: .code)
        self.name = try container.decode(String.self, forKey: .name)
        self.city = try city.decode(String.self, forKey: .name)
    }
}
