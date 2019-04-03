//
//  BookingOptionSet.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-03-14.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/**
 Some experiences require an additional booking option for the availability
 as well as the booking. An exmaple of this might be the different times a
 certain tour is offered.
 */

public struct BookingOptionSet: Decodable {
    /// The label for the options. In the time example this would read "Time"
    public let label: String
    /// The availabile `BookingOption`s in this set.
    public let options: [BookingOption]

    enum CodingKeys: String, CodingKey {
        case label = "optionSetLabel"
        case options = "options"
    }
}
