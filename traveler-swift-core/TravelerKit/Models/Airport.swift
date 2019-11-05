//
//  Airport.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-10-17.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

/// Represents information about an airport
public struct Airport: Codable, Equatable {
    /// IATA code
    public let code: String
    /// Airport name
    public let name: String
    /// City
    public let city: String
    /// Timezone
    public let timeZone: TimeZone

    enum CodingKeys: String, CodingKey {
        case code = "iata"
        case name = "name"
        case city = "city"
        case utcOffsetHours = "utcOffsetHours"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(code, forKey: .code)
        try container.encode(name, forKey: .name)
        try container.encode(city, forKey: .city)
        try container.encode(Double(timeZone.secondsFromGMT()) / 3600, forKey: .utcOffsetHours)
    }

    init(code: String, name: String, city: String, timeZone: TimeZone) {
        self.code = code
        self.name = name
        self.city = city
        self.timeZone = timeZone
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.code = try container.decode(String.self, forKey: .code)
        self.name = try container.decode(String.self, forKey: .name)
        self.city = try container.decode(String.self, forKey: .city)

        let utcOffsetHours = try container.decode(Double.self, forKey: .utcOffsetHours)
        let offsetSeconds = Int(utcOffsetHours * 3600)

        guard let timeZone = TimeZone(secondsFromGMT: offsetSeconds) else {
            throw DecodingError.dataCorruptedError(forKey: .utcOffsetHours, in: container, debugDescription: "Wrong format for UTC offset hours, can't create TimeZone")
        }

        self.timeZone = timeZone
    }
}
