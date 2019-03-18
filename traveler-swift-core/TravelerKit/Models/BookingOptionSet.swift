//
//  BookingOptionSet.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-03-14.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public struct BookingOptionSet: Decodable {
    public let label: String
    public let options: [BookingOption]

    enum CodingKeys: String, CodingKey {
        case label = "optionSetLabel"
        case options = "options"
    }
}
