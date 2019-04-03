//
//  ContactInfo.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-08.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

/// Contact information of a business/vendor
public struct ContactInfo: Decodable {
    /// Name
    public let name: String
    /// Email address
    public let email: String?
    /// Optional website
    public let website: String?
    /// Optional array of phone numbers
    public let phones: [String]?
}
