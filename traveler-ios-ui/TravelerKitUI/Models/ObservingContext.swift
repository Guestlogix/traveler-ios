//
//  ObservingContext.swift
//  TravelerKitUI
//
//  Created by Ben Ruan on 2019-11-20.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation

public class ObservingContext {
    struct ObserverWrapper {
        weak var observer: AnyObject?
    }
    var observerWrappers = [ObjectIdentifier: ObserverWrapper]()

    func addObserver(_ observer: AnyObject) {
        let id = ObjectIdentifier(observer)
        observerWrappers[id] = ObserverWrapper(observer: observer)
    }

    func removeObserver(_ observer: AnyObject) {
        let id = ObjectIdentifier(observer)
        observerWrappers.removeValue(forKey: id)
    }
}
