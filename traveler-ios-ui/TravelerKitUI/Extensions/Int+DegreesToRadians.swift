//
//  Int+DegreesToRadians.swift
//  TravelerKitUI
//
//  Created by Ben Ruan on 2019-09-16.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation

extension Int {
    var degreesToRadians: CGFloat { return CGFloat(self) * .pi / 180 }
}
