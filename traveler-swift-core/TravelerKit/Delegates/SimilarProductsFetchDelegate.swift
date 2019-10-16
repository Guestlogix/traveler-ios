//
//  SimilarProductsFetchDelegate.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-10-16.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation
/// Notified of similar product fetch results
public protocol SimilarProductsFetchDelegate: class {

    /**
     Called when similar products were fetched successfuly
     
     - Parameters:
     - result: Fetched `Catalog`
     */
    func similarItemsFetchDidSucceedWith(_ result: Catalog)

    /**
     Called when there was an error fetching the catalog

     - Parameters:
     - error: The `Error` representing the reason for failure.
     */
    func similarItemsFetchDidFailWith(_ error: Error)
}
