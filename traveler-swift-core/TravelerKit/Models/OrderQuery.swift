//
//  OrderQuery.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-05-06.
//  Copyright © 2019 Guestlogix Inc. All rights reserved.
//

import Foundation

/**
 This type is used to accurately retrieve a list of past orders that interest the user.
 */
public struct OrderQuery: Equatable {
    /// Pagination offset
    public let offset: Int
    /// Pagination limit
    public let limit: Int
    /// Start date (Orders that were made after this date)
    public let fromDate: Date?
    /// End date (Orders that were made before this date)
    public let toDate: Date

    /**
     Initializes an `OrderQuery`

     - Parameters:
     - offset: Pagination offset, default to 0
     - limit: Pagination limit, defualt to 10
     - from: Orders that were made after this date, default to nil
     - to: Orders that were made before this date, passing nil will default to NOW
     */
    public init(offset: Int = 0, limit: Int = 10, from: Date? = nil, to: Date? = nil) {
        self.offset = offset
        self.limit = 0
        self.fromDate = from
        self.toDate = to ?? Date()
    }
}
