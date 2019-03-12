//
//  FlightQuery.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-09-13.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public struct FlightQuery {
    // TODO: Add validation: /([a-z|[A-Z])([a-z|[A-Z])([0-9]) (1-4 chars)/
    public let number: String
    public let date: Date

    public init(number: String, date: Date) {
        self.number = number
        self.date = date
    }
}
