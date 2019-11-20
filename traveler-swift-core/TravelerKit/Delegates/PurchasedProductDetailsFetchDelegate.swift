//
//  PurchasedProductDetailsFetchDelegate.swift
//  TravelerKit
//
//  Created by Rakin Hoque on 2019-11-27.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// Notified of any purchased item details fetch results
public protocol PurchasedProductDetailsFetchDelegate: class {
    /**
     Called when the `AnyPurchasedProductDetails` was fetched successfully

     - Parameters:
     - result: Fetched `AnyPurchasedProductDetails`
     */
    func purchasedProductDetailsFetchDidSucceedWith(_ result: AnyPurchasedProductDetails)

    /**
     Called when there was an error fetching any purchased item details

     - Parameters:
     - error: The `Error` representing the reason for failure. No specific errors
     to look for here. Best course of action is to just display a generic error
     message.
     */
    func purchasedProductDetailsFetchDidFailWith(_ error: Error)
}
