//
//  FetchOfferingsDelegate.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-12-02.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation
/// Notified of fetch offerings results
public protocol FetchOfferingsDelegate: class {

    /**
     Called when offerings were fetched successfuly
     - Parameters:
        - result: An array of fetched `PartnerOfferingGroup`
     */
    func fetchOfferingsDidSucceedWith(_ result: [PartnerOfferingGroup])

    /**
     Called when there was an error fetching the catalog
     - Parameters:
        - error: The `Error` representing the reason for failure
     */
    func fetchOfferingsDidFailWith(_ error: Error)
}
