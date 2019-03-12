//
//  Location.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-11-08.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public struct Location: Decodable {
    public let address: String
    public let latitude: Double
    public let longitude: Double
}
