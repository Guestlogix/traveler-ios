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

    /**
     Initializes a `BoundingBox`
     - Parameters:
     - topLeftCoordinate: A `Coordinate` that represents the top left corner of the bounding box
     - bottomRightCoordinate: A `Coordinate` that represents the bottom right coordinate of the bounding box
     */

    public init(topLeftCoordinate: Coordinate, bottomRightCoordinate: Coordinate) {
        self.topLeftCoordinate = topLeftCoordinate
        self.bottomRightCoordinate = bottomRightCoordinate
    }
}

extension BoundingBox: Equatable {
    public static func == (lhs: BoundingBox, rhs: BoundingBox) -> Bool {
        return lhs.topLeftCoordinate == rhs.topLeftCoordinate && lhs.bottomRightCoordinate == rhs.bottomRightCoordinate
    }
}
