//
//  ObservingContext.swift
//  TravelerKitUI
//
//  Created by Ben Ruan on 2019-11-20.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation

public class ObservingContext {
    struct ObservationWrapper {
        weak var observer: AnyObject?
    }
    var observations = [ObjectIdentifier: ObservationWrapper]()

    func addObserver(_ observer: AnyObject) {
        let id = ObjectIdentifier(observer)
        observations[id] = ObservationWrapper(observer: observer)
    }

    func removeObserver(_ observer: AnyObject) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
    }
}
