//
//  CustomerContact.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2019-02-04.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public struct CustomerContact: Decodable {
    public let title: String?
    public let firstName: String
    public let lastName: String
    public let email: String?
    public let phone: String?
}
