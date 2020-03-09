//
//  DateRangeFilter.swift
//  TravelerKit
//
//  Created by Ben Ruan on 2020-03-09.
//  Copyright © 2020 Guestlogix. All rights reserved.
//

import Foundation
/**
 A model represeting a filter that relates to range of availability dates.
 */
public struct DateRangeFilter: Equatable {
    /// The range of availability dates with which the items should be filtered
    public let range: ClosedRange<Date>

    public init(range: ClosedRange<Date>) {
        self.range = range
    }
}
