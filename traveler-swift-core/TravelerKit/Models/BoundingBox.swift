//
//  BoundingBox.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-08-20.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation
/**
 A model represeting a bounding box that represents a geographic area.
 */
public struct BoundingBox: Equatable {
    /// The latitude for the top left corner of the bounding box
    public let topLeftLatitude: Double
    /// The longitude for the top left corner of the bounding box
    public let topLeftLongitude: Double
    /// The latitude for the bottom right corner of the bounding box
    public let bottomRightLatitude: Double
    /// The longitude for the bottom right corner of the bounding box
    public let bottomRightLongitude: Double
}
