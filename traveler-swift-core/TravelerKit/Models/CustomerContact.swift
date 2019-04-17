//
//  CustomerContact.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-02-04.
//  Copyright © 2019 Guestlogix. All rights reserved.
//

import Foundation

/// Information about a customer
public struct CustomerContact: Decodable {
    /// Their title. e.g. "Mr" or "Mrs"
    public let title: String?
    /// Their first name
    public let firstName: String?
    /// Their last name
    public let lastName: String?
    /// Their email address
    public let email: String
    /// Their phone number
    public let phone: String?
}
