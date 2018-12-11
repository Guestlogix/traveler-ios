//
//  Schedule.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-11-23.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public struct Availability: Decodable {
    public let date: Date
    public let times: [Time]
    public let isAvailable: Bool

    enum CodingKeys: String, CodingKey {
        case date = "date"
        case times = "timesInMinutes"
        case isAvailable = "available"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.isAvailable = try container.decode(Bool.self, forKey: .isAvailable)
        self.times = try container.decode([Int].self, forKey: .times)

        let dateString = try container.decode(String.self, forKey: .date)

        if let date = DateFormatter.dateOnlyFormatter.date(from: dateString) {
            self.date = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.date, in: container, debugDescription: "Incorrect format")
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
