//
//  Timezone+UTCOffset.swift
//  TravelerKit
//
//  Created by Omar Padierna on 2019-07-11.
//  Copyright © 2019 Ata Namvari. All rights reserved.
//

import Foundation

extension TimeZone {
    init? (with utcOffsetHours:String) {
        //Expecting "+/-HH.HH" and converting to "+/-H"
        let hourString = utcOffsetHours.dropLast(2)
        if let offsetHour = Int(hourString) {
            self.init(secondsFromGMT: offsetHour * 3600)
            return
        } else {
            return nil
        }
    }
}
