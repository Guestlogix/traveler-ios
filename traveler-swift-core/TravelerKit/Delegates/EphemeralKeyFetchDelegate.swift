//
//  EphemeralKeyFetchDelegate.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-11-11.
//  Copyright © 2019 Guestlogix. All rights reserved.
//

import Foundation
/// Notified of similar ephemeral key fetch results
public protocol EphemeralKeyFetchDelegate: class {

    /**
     Called when ephemeral key was fetched successfuly

     - Parameters:
     - result: An `EphemeralKey` type which contains the key in JSON format
     */
    func ephemeralKeyFetchDidSucceedWith(_ result: EphemeralKey)

    /**
     Called when there was an error fetching the ephemeral key

     - Parameters:
     - error: The `Error` representing the reason for failure.
     */
    func ephemeralKeyFetchDidFailWith(_ error: Error)
}
