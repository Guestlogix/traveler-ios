//
//  EmailTicketsDelegate.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-06-21.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// Notified of sending tickets by email
public protocol EmailTicketsDelegate: class {
    /**
     Called when the tickets were sent successfully
     - Parameters:
     */
    func emailDidSucceed()
    /**
     Called when there was an error sending the tickets

     - Parameters:
     - error: The `Error` representing the reason for failure.
     */
    func emailDidFailWith(_ error: Error)
}
