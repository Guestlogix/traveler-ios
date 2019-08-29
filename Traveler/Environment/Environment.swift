//
//  Environment.swift
//  Traveler
//
//  Created by Omar Padierna on 2019-07-05.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation

struct Environment {

    static var gIDClientId: String = "722316764255-7n0gp3v0061nh12t7ghckg969orp6rc3.apps.googleusercontent.com"//$(GID_CLIENT_ID)
    static var gIDServerClientID: String = "722316764255-b5b818k7flnugh4brq17r6jmqt71cddr.apps.googleusercontent.com"//$(GID_SERVER_CLIENT_ID)

    #if GCREW
    static var travelerKitKey: String = "pub_nGuuZFGuVuk1MVMKhFV1Gn1V1vGKuvFhhhk1_"//$(TRAVELER_KIT_API_KEY)
    #endif

    #if TRAVELER
    static var travelerKitKey: String = "testtesttesttesttest"//$(TRAVELER_KIT_API_TEST_KEY)
    #endif
}
