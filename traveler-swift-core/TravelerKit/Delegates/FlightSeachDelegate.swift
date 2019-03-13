//
//  FlightSeachDelegate.swift
//  TravelerKit
//
//  Created by Ata Namvari on 2018-10-17.
//  Copyright © 2018 Ata Namvari. All rights reserved.
//

import Foundation

public protocol FlightSearchDelegate: class {
    func flightSearchDidSucceedWith(_ result: [Flight])
    func flightSearchDidFailWith(_ error: Error)
}
