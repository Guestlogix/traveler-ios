//
//  Supplier.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-07-17.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// Holds information about a supplier
public struct Supplier: Decodable {
    /// The `Supplier`s name
    public let name: String
    /// The `Supplier`s trademark
    public let trademark: Trademark?

    enum CodingKeys: String, CodingKey {
        case name
        case trademark
    }
}
