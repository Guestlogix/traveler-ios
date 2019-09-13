//
//  BookingOption.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-03-12.
//  Copyright © 2019 Guestlogix. All rights reserved.
//

import Foundation

/**
 Holds the value for a `BookingOption`
 */

public struct BookingOption: Decodable, Equatable {
    let id: String

    /**
     The value of the option. If for example the `BookingOptionSet` is time,
     then this would read something like "11:00 am".
     */
    public let value: String
    /**
     A disclaimer for that option. These disclaimers may contain start times and information on levies
     */
    public let disclaimer: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case value = "optionLabel"
        case disclaimer = "disclaimer"
    }

    public static func ==(lhs: BookingOption, rhs: BookingOption) -> Bool {
        return lhs.id == rhs.id
    }
}
