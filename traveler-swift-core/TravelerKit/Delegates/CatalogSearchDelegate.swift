//
//  CatalogSearchDelegate.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-08-07.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// Notified of catalog search results
public protocol CatalogSearchDelegate: class {

    /**
     Called when the `Catalog` was searched successfully

     - Parameters:
     - result: `Catalog` filtered by search query
     */
    func catalogSearchDidSucceedWith(_ result: Catalog)

    /**
     Called when there was an error searching the catalog

     - Parameters:
     - error: The `Error` representing the reason for failure. No specific errors
     to look for here. Best course of action is to just display a generic error
     message.
     */
    func catalogSearchDidFailWith(_ error: Error)
}
