//
//  Profile.swift
//  Traveler
//
//  Created by Ata Namvari on 2019-03-28.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation

struct Profile: Codable {
    let travelerId: String
    let firstName: String
    let lastName: String
    let email: String
    let avatarURL: URL

    enum CodingKeys: String, CodingKey {
        case travelerId = "travelerId"
        case firstName = "firstName"
        case lastName = "lastName"
        case email = "email"
        case avatarURL = "avatar"
    }
}
