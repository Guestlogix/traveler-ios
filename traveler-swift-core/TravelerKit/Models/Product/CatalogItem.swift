//
//  Purchasable.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-10-25.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

/// An item in the `CatalogGroup`
public protocol CatalogItem {
    /// Title
    var title: String { get }
    /// Secondary title
    var subTitle: String? { get }
    /// URL for a thumbnail
    var imageURL: URL? { get }
    /// Indicates if item is available
    var isAvailable: Bool { get }
}
