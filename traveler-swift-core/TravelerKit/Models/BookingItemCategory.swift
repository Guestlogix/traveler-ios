//
//  BookingItemCategory.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-07-19.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation
/// Represents the different categories a `BookingItem` can have
public struct BookingItemCategory: Decodable {
    //The id for the category
    public let id: String
    //The title for the category
    public let title: String

    enum codingKeys: String, CodingKey {
        case id = "id"
        case label = "label"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: codingKeys.self)

        self.id = try container.decode(String.self, forKey: .id)
        self.title = try container.decode(String.self, forKey: .label)
    }
}

extension BookingItemCategory: Equatable {
    
}
