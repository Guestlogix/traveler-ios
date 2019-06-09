//
//  Order+Equatable.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-06-09.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

extension Order: Equatable {
    public static func == (lhs: Order, rhs: Order) -> Bool {
        return lhs.id == rhs.id
    }
}


