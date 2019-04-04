//
//  CatalogItemDetailsFetchDelegate.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-11-07.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

/// Notified of catalog item fetch results
public protocol CatalogItemDetailsFetchDelegate: class {
    /**
     Called when the `CatalogItemDetails` was fetched successfully

     - Parameters:
     - result: Fetched `CatalogItemDetails`
     */
    func catalogItemDetailsFetchDidSucceedWith(_ result: CatalogItemDetails)
    /**
     Called when there was as error fetching the catalog item details

     - Parameters:
     - error: The `Error` representing the reason for failure. No specific errors
     to look for here. Best coarse of action is to just display a generic error
     message.
     */
    func catalogItemDetailsFetchDidFailWith(_ error: Error)
}
