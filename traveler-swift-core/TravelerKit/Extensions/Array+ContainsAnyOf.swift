//
//  Array+ContainsAnyOf.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-12-05.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

extension Array where Element : Equatable {
    public func containsAnyOf(_ elements: Array) -> Bool {
        for element in elements where self.contains(element) {
            return true
        }
        return false
    }
}
