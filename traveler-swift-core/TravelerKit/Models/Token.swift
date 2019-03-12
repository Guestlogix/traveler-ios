//
//  Token.swift
//  Guestlogix
//
//  Created by TribalScale on 5/18/18.
//  Copyright © 2018 TribalScale. All rights reserved.
//

import Foundation

struct Token: Codable {
    var value: String
    
    private enum CodingKeys: String, CodingKey {
        case value = "token"
    }
}

extension URLRequest {
    mutating func addAuthHeaders(token: Token) {
        addValue(token.value, forHTTPHeaderField: "x-custom-auth-token")
    }
}
