//
//  Session.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-09-14.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

enum SessionError: Error {
    case noToken
}

class Session: Codable {
    let apiKey: String

    var token: Token?
    var identity: String?

    init(apiKey: String) {
        self.apiKey = apiKey
    }
}
