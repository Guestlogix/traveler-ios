//
//  Environment.swift
//  Traveler
//
//  Created by Omar Padierna on 2019-07-05.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation

struct Environment {
    static var gIDClientId: String = "$(GID_CLIENT_ID)"
    static var gIDServerClientID: String = "$(GID_SERVER_CLIENT_ID)"
    #if GCREW
    static var travelerKitKey: String = "$(TRAVELER_KIT_API_KEY)"
    #endif
    
    #if TRAVELER
    static var travelerKitKey: String = "$(TRAVELER_KIT_TEST_API_KEY)"
    #endif
}
