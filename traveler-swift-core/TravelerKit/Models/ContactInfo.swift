//
//  ContactInfo.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-08.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public struct ContactInfo: Decodable {
    public let name: String
    public let email: String?
    public let website: String?
    public let phones: [String]?
}
