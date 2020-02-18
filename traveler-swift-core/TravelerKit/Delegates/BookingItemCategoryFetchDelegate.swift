//
//  BookingItemCategoryFetchDelegate.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2020-02-18.
//  Copyright © 2020 Guestlogix. All rights reserved.
//

import Foundation

///Notified of BookingItemCategory fetch results
public protocol BookingItemCategoryFetchDelegate: class {
    /**
     Called when fetching  categories for BookingItems
     - Parameters:
        - result: An array of `BookingItemCategory` items referring to the categories
     */
    func bookingItemCategoryFetchDidSuccedWith(_ result: [BookingItemCategory])

    /**
     Called when fetching categories failed
     - Parameters:
        - error: An `Error` explaining the results
     */
    func bookingItemCategoryFetchDidFailWith(_ error: Error)
}
