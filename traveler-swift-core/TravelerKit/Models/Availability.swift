//
//  Schedule.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-23.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

/// Represent a date for which there is availability (in the context of a bookabke producy)
public struct Availability: Decodable {
    let id: String
    /// The available date
    public let date: Date
    /// The options available for that date
    public let optionSet: BookingOptionSet?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case date = "date"
        case optionSet = "optionSet"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)

        let dateString = try container.decode(String.self, forKey: .date)

        if let date = DateFormatter.dateOnlyFormatter.date(from: dateString) {
            self.date = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.date, in: container, debugDescription: "Incorrect format")
        }

        self.optionSet = try container.decodeIfPresent(BookingOptionSet.self, forKey: .optionSet)
    }
}
