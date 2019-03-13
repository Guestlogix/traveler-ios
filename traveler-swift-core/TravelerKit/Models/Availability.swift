//
//  Schedule.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-11-23.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public enum AvailabilityError: Error {
    case badDate
}

public struct Availability: Decodable {
    let id: String
    public let date: Date
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

        if container.contains(.optionSet) {
            self.optionSet = try container.decode(BookingOptionSet.self, forKey: .optionSet)
        } else {
            self.optionSet = nil
        }
    }
}

public typealias Time = Int

extension Time {
    public var formattedValue: String {
        let dateComponents = DateComponents(minute: self)
        let date = Calendar.current.date(from: dateComponents)!
        return DateFormatter.timeFormatter.string(from: date)
    }
}
