//
//  FlightQuery.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-09-13.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public struct FlightQuery {
    var carrierCode: String
    var number: String
    var date: Date

    public init(carrierCode: String, number: String, date: Date) {
        self.carrierCode = carrierCode
        self.number = number
        self.date = date
    }
}
