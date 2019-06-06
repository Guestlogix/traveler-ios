//
//  Product+EventDate.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-06-06.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

extension Product {
    public var eventDateDescription: String? {
        switch self {
        case is BookableProduct:
            return self.eventDateDescription
        default:
            return nil
        }
    }
}
