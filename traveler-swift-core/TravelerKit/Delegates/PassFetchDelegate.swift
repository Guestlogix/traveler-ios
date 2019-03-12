//
//  PassFetchDelegate.swift
//  PassengerKit
//
//  Created by Ata Namvari on 2018-12-05.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public protocol PassFetchDelegate: class {
    func passFetchDidSucceedWith(_ result: [Pass])
    func passFetchDidFailWith(_ error: Error)
}
