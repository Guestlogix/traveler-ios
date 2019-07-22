//
//  Environment.swift
//  Traveler
//
//  Created by Omar Padierna on 2019-07-05.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation

struct Environment {
    #if GCREW
    static var travelerKitKey: String = "$(TRAVELER_KIT_API_KEY)"
    static var gIDClientId: String = "$(GID_CLIENT_ID)"
    static var gIDServerClientID: String = "$(GID_SERVER_CLIENT_ID)"
    #endif
    
    #if TRAVELER
    static var travelerKitKey: String = ProcessInfo.processInfo.environment["TRAVELER_KIT_TEST_API_KEY"]!
    static var gIDClientId: String = ProcessInfo.processInfo.environment["GID_CLIENT_ID"]!
    static var gIDServerClientID: String = ProcessInfo.processInfo.environment["GID_SERVER_CLIENT_ID"]!
    #endif
}
