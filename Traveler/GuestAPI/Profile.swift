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

    enum CodingKeys: String, CodingKey {
        case travelerId = "travelerId"
        case firstName = "firstName"
        case lastName = "lastName"
        case email = "email"
    }

    static var storedProfile: Profile? {
        guard let data = UserDefaults.standard.data(forKey: profileKey) else {
            return nil
        }

        return try? JSONDecoder().decode(Profile.self, from: data)
    }

    static func clearStoredProfile() {
        UserDefaults.standard.removeObject(forKey: profileKey)
    }

    func store() {
        guard let data = try? JSONEncoder().encode(self) else {
            return
        }

        UserDefaults.standard.set(data, forKey: profileKey)
    }
}
