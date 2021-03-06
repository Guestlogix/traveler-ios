//
//  PurchaseFormFetchDelegate.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2019-03-12.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// Notified of product form fetch results
public protocol PurchaseFormFetchDelegate: class {
    /**
     Called when there was an error processing the order

     - Parameters:
     - error: The `Error` representing the reason for failure. No specific errors
     to look for here. Best course of action is to just display a generic error
     message.
     */
    func purchaseFormFetchDidFailWith(_ error: Error)
    /**
     Called when the booking form was fetched successfully

     - Parameters:
     - purchaseForm: Fetched `PurchaseForm`
     */
    func purchaseFormFetchDidSucceedWith(_ purchaseForm: PurchaseForm)
}
