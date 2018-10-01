//
//  Identifier.swift
//  Guestlogix
//
//  Created by TribalScale on 7/13/18.
//  Copyright © 2018 TribalScale. All rights reserved.
//

struct Identifier: Codable {
    let value: String
    
    private enum CodingKeys: String, CodingKey {
        case value = "id"
    }
}


