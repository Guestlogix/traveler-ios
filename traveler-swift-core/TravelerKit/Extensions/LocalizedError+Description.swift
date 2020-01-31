//
//  LocalizedError+Description.swift
//  TravelerKit
//
//  Created by Josip Petric on 31/01/2020.
//  Copyright © 2020 Guestlogix. All rights reserved.
//

import Foundation

extension LocalizedError {
    func localizedDescription(description: String, withTraceId traceId: String) -> String {
        return "\(description)\nTrace Id: \(traceId)"
    }
}
