//
//  Calendar+Gregorian.swift
//  TravelerKit
//
//  Created by Josip Petric on 05/02/2020.
//  Copyright © 2020 Ata Namvari. All rights reserved.
//

import Foundation

extension Calendar {
    static func gregorian() -> Calendar {
        let calendar = Calendar(identifier: .gregorian)
        return calendar
    }
}
