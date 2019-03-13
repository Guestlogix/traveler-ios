//
//  CatalogItemDetailsFetchDelegate.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-07.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public protocol CatalogItemDetailsFetchDelegate: class {
    func catalogItemDetailsFetchDidSucceedWith(_ result: CatalogItemDetails)
    func catalogItemDetailsFetchDidFailWith(_ error: Error)
}
