//
//  ProductOffering.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-11-23.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation
//TODO: Find a better name for this protocol. Both passes and PartnerOffering conform to it, but it doesn't sound right for passes. 
 /// An offering for a `Product`
public protocol ProductOffering {
    /// Id
    var id: String { get } 
    /// Title
    var name: String { get }
    /// Description
    var description: String? { get }
}
