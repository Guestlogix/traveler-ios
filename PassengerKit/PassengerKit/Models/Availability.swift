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
}

public typealias Time = Int

extension Time {
    public var formattedValue: String {
        let dateComponents = DateComponents(minute: self)
        let date = Calendar.current.date(from: dateComponents)!
        return DateFormatter.timeFormatter.string(from: date)
    }
}
