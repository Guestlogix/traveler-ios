//
//  ParkingFilterContext.swift
//  TravelerKitUI
//
//  Created by Omar Padierna on 2019-11-07.
//  Copyright © 2019 GuestLogix. All rights reserved.
//

import Foundation

public protocol ParkingFilterContextObserving: class {
    func parkingFilterContextDidChangeSelectedFilter(_ context: ParkingFilterContext)
}

public class ParkingFilterContext {
    private(set) var filter: Int?

    private weak var delegate: ParkingFilterContextObserving?

    var selectedFilter: Int? {
        didSet {
            notifyObserver()
        }
    }

    private struct Observation {
        weak var observer: ParkingFilterContextObserving?
    }
    private var observations = [ObjectIdentifier: Observation]()

    func addObserver(_ observer: ParkingFilterContextObserving) {
        let id = ObjectIdentifier(observer)
        observations[id] = Observation(observer: observer)
    }

    func removeObserver(_ observer: ParkingFilterContextObserving) {
        let id = ObjectIdentifier(observer)
        observations.removeValue(forKey: id)
    }

    func notifyObserver() {
        for (id, observation) in observations {
            guard let observer = observation.observer else {
                observations.removeValue(forKey: id)
                continue
            }

            observer.parkingFilterContextDidChangeSelectedFilter(self)
        }
    }
}
