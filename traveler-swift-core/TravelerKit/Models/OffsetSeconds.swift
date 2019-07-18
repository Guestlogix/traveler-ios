//
//  OffsetSeconds.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-07-18.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

/// Contains information about UTC offset seconds
public struct OffsetSeconds {

    /// Offset Hours stored as an integer
    public let value: Int

    init(offsetSeconds: Int) {
        self.value = offsetSeconds
    }

    public init?(offsetHourString: String) {
        //Expecting "+/-HH.HH" and converting to "+/-H"
        let hourString = offsetHourString.dropLast(2)
        if let offsetHour = Int(hourString) {
            let offsetSeconds = offsetHour * 3600
            self.init(offsetSeconds: offsetSeconds)
            return
        } else {
            return nil
        }
    }
}
