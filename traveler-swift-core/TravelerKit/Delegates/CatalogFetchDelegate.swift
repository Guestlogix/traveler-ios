//
//  CatalogFetchDelegate.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-10-25.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public protocol CatalogFetchDelegate: class {
    func catalogFetchDidSucceedWith(_ result: Catalog)
    func catalogFetchDidFailWith(_ error: Error)
}
