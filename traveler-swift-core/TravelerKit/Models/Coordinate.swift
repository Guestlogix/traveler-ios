//
//  Coordinate.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-10-07.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

///A geographic coordinate
public struct Coordinate: Decodable, Equatable {
    public let latitude: Double
    public let longitude: Double

    /**
     Initializes a `Coordinate`
     - Parameters:
     - latitude: A double representing the latitude
     - longitude: A double representing the longitude
     */

    public init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
}
