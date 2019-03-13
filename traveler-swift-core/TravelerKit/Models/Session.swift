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
    private(set) var user: User

    var token: Token?

    init(apiKey: String) {
        self.apiKey = apiKey
        self.user = User()
    }

    func merge(_ session: Session) {
        self.token = session.token
        self.user.merge(session.user)
    }
}
