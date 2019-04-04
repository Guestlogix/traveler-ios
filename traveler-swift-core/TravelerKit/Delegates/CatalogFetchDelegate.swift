//
//  CatalogFetchDelegate.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-10-25.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

/// Notified of catalog fetch results
public protocol CatalogFetchDelegate: class {
    /**
     Called when the `Catalog` was fetched successfully

     - Parameters:
     - result: Fetched `Catalog`
     */
    func catalogFetchDidSucceedWith(_ result: Catalog)
    /**
     Called when there was as error fetching the catalog

     - Parameters:
     - error: The `Error` representing the reason for failure. No specific errors
        to look for here. Best coarse of action is to just display a generic error
        message.
     */
    func catalogFetchDidFailWith(_ error: Error)
}
