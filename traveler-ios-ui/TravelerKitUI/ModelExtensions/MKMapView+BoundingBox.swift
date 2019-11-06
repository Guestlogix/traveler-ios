//
//  MKMapView+BoundingBox.swift
//  TravelerKitUI
//
//  Created by Ata Namvari on 2019-10-24.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation
import MapKit
import TravelerKit

extension MKMapRect {
    init(boundingBox: BoundingBox) {
        let coordinate1 = CLLocationCoordinate2DMake(boundingBox.topLeftCoordinate.latitude, boundingBox.topLeftCoordinate.longitude)
        let coordinate2 = CLLocationCoordinate2DMake(boundingBox.bottomRightCoordinate.latitude, boundingBox.bottomRightCoordinate.longitude)

        // convert them to MKMapPoint
        let p1 = MKMapPoint(coordinate1)
        let p2 = MKMapPoint(coordinate2)

        // and make a MKMapRect using mins and spans
        self.init(x: fmin(p1.x,p2.x), y: fmin(p1.y,p2.y), width: fabs(p1.x-p2.x), height: fabs(p1.y-p2.y))
    }
}
