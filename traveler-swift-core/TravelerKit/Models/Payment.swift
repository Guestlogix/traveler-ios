//
//  Payment.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-02-08.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

public protocol Payment {
    var attributes: [Attribute] { get }

    func securePayload() -> Data?
}
