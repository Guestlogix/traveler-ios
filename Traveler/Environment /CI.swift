//
//  CI.swift
//  Traveler
//
//  Created by Omar Padierna on 2019-06-27.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation

struct CI {
    static var gIDClientId: String = "$(GID_CLIENT_ID)"
    static var gIDServerClientID: String = "$(GID_SERVER_CLIENT_ID)"
    static var travelerKitKey: String = "$(TRAVELER_KIT_API_KEY)"
}
