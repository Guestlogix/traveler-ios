//
//  Facets+TravelerUI.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-09-06.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit

enum FacetType {
    case prices
    case category
}

extension Facets {
    var availableFacets: [FacetType] {
        get {
            var activeFacets = [FacetType]()

            activeFacets.append(.prices)

            if self.categories.count != 0 {
                activeFacets.append(.category)
            }
            
            return activeFacets
        }
    }

}
