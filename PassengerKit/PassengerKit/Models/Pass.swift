//
//  Pass.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-12-05.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public struct Pass: Decodable, Hashable {
    let id: String

    public let name: String
    public let description: String?
    public let maxQuantity: Int?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case description = "description"
        case maxQuantity = "maximumQuantity"
    }
}
