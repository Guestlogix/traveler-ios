//
//  ProductItemSort+TravelerUI.swift
//  TravelerKitUI
//
//  Created by Rakin Hoque on 2019-11-25.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit

extension ProductItemSort {
    var rowInformation: (title: String, path: IndexPath) {
        switch self {
        case .priceAscending:
            return (title: "Price: Low to high", path: IndexPath(row: 0, section: 0))
        case .priceDescending:
            return (title: "Price: High to low", path: IndexPath(row: 1, section: 0))
        case .titleAscending:
            return (title: "Title: Ascending", path: IndexPath(row: 2, section: 0))
        case .titleDescending:
            return (title: "Title: Descending", path: IndexPath(row: 3, section: 0))
        }
    }
}
