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

public class ParkingFilterContext: ObservingContext {
    private(set) var filter: Int?

    private weak var delegate: ParkingFilterContextObserving?

    var selectedFilter: Int? {
        didSet {
            notifyObserver()
        }
    }

    func notifyObserver() {
        for (id, observation) in observations {
            guard let observer = observation.observer, let filterObserver = observer as? ParkingFilterContextObserving else {
                observations.removeValue(forKey: id)
                continue
            }

            filterObserver.parkingFilterContextDidChangeSelectedFilter(self)
        }
    }
}
