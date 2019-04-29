//
//  OrderGroup.swift
//  TravelerKit
//
//  Created by Dorothy Fu on 2019-04-23.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// Group of `Order`s
public struct OrderGroup: Decodable {
    public let result: [Order]
}
