//
//  BoundingBox+Radius.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-11-07.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit
import CoreLocation

extension BoundingBox {
    init? (with location: CLLocation?, radius: Double) {
        guard let location = location else {
            return nil
        }

        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        let earthRadius = 6371.0 //in Kilometers
        let dY = 360 * (radius / earthRadius)
        let dX = dY * cos(latitude * .pi/180)

        let topLeftCoordinate = Coordinate(latitude: latitude - dY, longitude: longitude - dX)
        let bottomRightCoordinate = Coordinate(latitude: latitude + dY, longitude: longitude + dX)

        self = BoundingBox(topLeftCoordinate: topLeftCoordinate, bottomRightCoordinate: bottomRightCoordinate)
    }
}
