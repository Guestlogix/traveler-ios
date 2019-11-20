//
//  ItineraryItem.swift
//  TravelerKit
//
//  Created by Rakin Hoque on 2019-11-21.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public struct ItineraryItem: Decodable {
    /// The product identifier
    public let id: String
    /// A display image
    public let thumbnailURL: URL?
    /// The order identifier
    public let orderId: String?
    /// Type
    public let type: ItineraryItemType
    /// A title
    public let title: String
    /// A secondary title
    public let subTitle: String
    /// Date in which item begins
    public let startDate: Date
    /// Date in which item completes
    public let endDate: Date?
    /// Duration in hours
    public let duration: TimeInterval?
    /// Coordinate representing item's initial location
    public let startLocation: Coordinate?
    /// Coordinate representing item's final location
    public let endLocation: Coordinate?
    /// Quantity of item
    public let quantity: Int?
    /// Denotes if item takes place all day long
    public let isAllDay: Bool

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case thumbnailURL = "iconUrl"
        case orderId = "orderId"
        case type = "type"
        case title = "title"
        case subTitle = "subTitle"
        case startDate = "startDateTime"
        case endDate = "endDateTime"
        case duration = "durationHours"
        case startLocation = "startLocation"
        case endLocation = "endLocation"
        case quantity = "reservationQuantity"
        case isAllDay = "isAllDay"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.thumbnailURL = try container.decode(URL?.self, forKey: .thumbnailURL)
        self.orderId = try container.decode(String?.self, forKey: .orderId)
        self.type = try container.decode(ItineraryItemType.self, forKey: .type)
        self.title = try container.decode(String.self, forKey: .title)
        self.subTitle = try container.decode(String.self, forKey: .subTitle)
        self.duration = try container.decode(TimeInterval?.self, forKey: .duration)
        self.startLocation = try container.decode(Coordinate?.self, forKey: .startLocation)
        self.endLocation = try container.decode(Coordinate?.self, forKey: .endLocation)
        self.quantity = try container.decode(Int.self, forKey: .quantity)
        self.isAllDay = try container.decode(Bool.self, forKey: .isAllDay)
        
        let startDateString = try container.decode(String.self, forKey: .startDate)
        
        if let startDate = DateFormatter.withoutTimezone.date(from: startDateString) {
            self.startDate = startDate
        } else {
            self.startDate = Date()
            throw DecodingError.dataCorruptedError(forKey: CodingKeys.startDate, in: container, debugDescription: "Incorrect format")
        }
        
        if let endDateString = try container.decode(String?.self, forKey: .endDate) {
            if let endDate = DateFormatter.withoutTimezone.date(from: endDateString) {
                self.endDate = endDate
            } else {
                self.endDate = nil
                throw DecodingError.dataCorruptedError(forKey: CodingKeys.endDate, in: container, debugDescription: "Incorrect format")
            }
        } else {
            self.endDate = nil
        }
    }
}
