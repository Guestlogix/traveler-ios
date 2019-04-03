//
//  Location.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-08.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

/// Represents a point on the map
public struct Location: Decodable {
    /// Address string
    public let address: String
    /// Latitude
    public let latitude: Double
    /// Longitude
    public let longitude: Double
}
