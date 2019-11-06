//
//  ParkingSpot.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-10-15.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import TravelerKit
import MapKit

class ParkingSpot: NSObject {
    let parkingItem: ParkingItem

    init(parkingItem: ParkingItem) {
        self.parkingItem = parkingItem
    }
}

extension ParkingSpot: MKAnnotation {
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: parkingItem.location.latitude, longitude: parkingItem.location.longitude)
    }
}
