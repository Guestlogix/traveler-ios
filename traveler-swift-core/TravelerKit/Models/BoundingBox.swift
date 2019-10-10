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
public struct BoundingBox {
    /// The latitude for the top left corner of the bounding box
    public let topLeftCoordinate: Coordinate
    /// The longitude for the bottom right corner of the bounding box
    public let bottomRightCoordinate: Coordinate
}

extension BoundingBox: Equatable {
    public static func == (lhs: BoundingBox, rhs: BoundingBox) -> Bool {
        return lhs.topLeftCoordinate == rhs.topLeftCoordinate && lhs.bottomRightCoordinate == rhs.bottomRightCoordinate
    }
}
